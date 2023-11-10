/*!

References:
  https://github.com/virtee/sev

  Convert:
    openssl::x509::X509::from_pem(pem_bytes)
    openssl::x509::X509::from_der(der_bytes)
    x509.to_der()
    x509.to_pem()
*/

use crate::{load_certs, pem_to_der, SnpError};
use crate::{ValidateAttestationError, ValidateAttestedStream};
use async_trait::async_trait;
use ic_base_types::{NodeId, RegistryVersion};
use ic_interfaces_registry::RegistryClient;
use ic_registry_client_helpers::{crypto::CryptoRegistry, node::NodeRegistry};
use openssl::ecdsa::EcdsaSig;
use openssl::x509::X509;
use serde::{Deserialize, Serialize};
use sev::firmware::guest::AttestationReport;
use sha2::Digest;

use std::path::Path;
use std::sync::Arc;
use tokio::io::{AsyncRead, AsyncReadExt, AsyncWrite, AsyncWriteExt};

#[derive(Deserialize, Serialize)]
pub struct AttestationPackage {
    pub report: AttestationReport,
    pub ask_der: Vec<u8>,
    pub vcek_der: Vec<u8>,
}

pub struct Sev {
    pub node_id: NodeId,
    pub registry: Arc<dyn RegistryClient>,
}

impl Sev {
    pub fn new(node_id: NodeId, registry: Arc<dyn RegistryClient>) -> Self {
        Self { node_id, registry }
    }
}

#[async_trait]
impl<S> ValidateAttestedStream<S> for Sev
where
    S: AsyncRead + AsyncWrite + Send + Unpin + 'static,
{
    async fn perform_attestation_validation(
        &self,
        mut stream: S,
        peer: NodeId,
        registry_version: RegistryVersion,
    ) -> Result<S, ValidateAttestationError> {
        // TODO: Replace this with `sev_status` feature check in subnet registry
        if true {
            return Ok(stream);
        }

        // Read seed_id, peer_tls_certificate, my tls_certificate from registry.
        let transport_info = self
            .registry
            .get_node_record(peer, registry_version)
            .map_err(ValidateAttestationError::RegistryError)?
            .ok_or(ValidateAttestationError::RegistryDataMissing {
                node_id: peer,
                registry_version,
                description: "transport_info missing".into(),
            })?;
        let node_operator_id = transport_info.node_operator_id;
        if node_operator_id.is_empty() {
            return Err(ValidateAttestationError::HandshakeError {
                description: "missing node_operator_id".into(),
            });
        }
        let chip_id = transport_info.chip_id;
        if chip_id.is_none() {
            return Err(ValidateAttestationError::HandshakeError {
                description: "missing chip_id.".into(),
            });
        }
        let peer_tls_certificate = self
            .registry
            .get_tls_certificate(peer, registry_version)
            .map_err(ValidateAttestationError::RegistryError)?
            .ok_or(ValidateAttestationError::RegistryDataMissing {
                node_id: peer,
                registry_version,
                description: "peer tls_certificate missing".into(),
            })?;
        let tls_certificate = self
            .registry
            .get_tls_certificate(self.node_id, registry_version)
            .map_err(ValidateAttestationError::RegistryError)?
            .ok_or(ValidateAttestationError::RegistryDataMissing {
                node_id: self.node_id,
                registry_version,
                description: "tls_certificate missing".into(),
            })?;

        // Get an attestation report with the hash of the tls certificate as report data.
        let mut guest_firmware = sev::firmware::guest::Firmware::open().map_err(|_| {
            ValidateAttestationError::HandshakeError {
                description: "unable to open sev guest firmware".into(),
            }
        })?;
        let tls_cert_hash = sha2::Sha256::digest(tls_certificate.certificate_der.as_slice());
        let mut report_data = [0u8; 64];
        report_data[..32].copy_from_slice(tls_cert_hash.as_slice());
        let report = guest_firmware
            .get_report(None, Some(report_data), Some(0) /* VMPL0 */)
            .map_err(|_| ValidateAttestationError::HandshakeError {
                description: "unable to get attestation report".into(),
            })?;
        let measurement = report.measurement;

        // Load the certs required to send with the report
        let certs = load_certs().map_err(|e| ValidateAttestationError::CertificatesError {
            description: format!("{}", e),
        })?;

        // Create my attestation package to send to the peer
        let package = AttestationPackage {
            report,
            ask_der: pem_to_der(&certs.ask),
            vcek_der: pem_to_der(&certs.vcek),
        };

        // Write my attestation package to peer.
        let serialized =
            serde_cbor::to_vec(&package).map_err(|_| ValidateAttestationError::HandshakeError {
                description: "unable to serialize attestation report".into(),
            })?;
        let len = serialized.len() as u32;
        let serialized_len = len.to_le_bytes();
        stream.write_all(&serialized_len).await.map_err(|_| {
            ValidateAttestationError::HandshakeError {
                description: "unable to write attestation report len".into(),
            }
        })?;
        stream.write_all(&serialized).await.map_err(|_| {
            ValidateAttestationError::HandshakeError {
                description: "unable to write attestation report".into(),
            }
        })?;

        // Read peer attestation package.
        let mut serialized_len = vec![0u8; 4];
        read_into_buffer(&mut stream, &mut serialized_len).await?;
        let len = u32::from_le_bytes(serialized_len.try_into().map_err(|_| {
            ValidateAttestationError::HandshakeError {
                description: "unable to convert serialized length".into(),
            }
        })?);
        let mut buffer: Vec<u8> = Vec::new();
        buffer.resize(len as usize, 0);
        read_into_buffer(&mut stream, &mut buffer).await?;
        let peer_package: AttestationPackage =
            serde_cbor::from_slice(buffer.as_slice()).map_err(|_| {
                ValidateAttestationError::HandshakeError {
                    description: "unable to deserialize attestation".into(),
                }
            })?;
        let peer_ask = X509::from_der(&peer_package.ask_der).map_err(|_| {
            ValidateAttestationError::HandshakeError {
                description: "bad peer ask certificate".into(),
            }
        })?;
        let peer_vcek = X509::from_der(&peer_package.vcek_der).map_err(|_| {
            ValidateAttestationError::HandshakeError {
                description: "bad peer vcek certificate".into(),
            }
        })?;

        // Validate peer attestation package.
        if !is_cert_chain_valid(certs.ark.as_ref().unwrap(), &peer_ask, &peer_vcek) {
            return Err(ValidateAttestationError::HandshakeError {
                description: "attestation cert chain invalid".to_string(),
            });
        }
        if !is_report_valid(&peer_package.report, &peer_vcek) {
            return Err(ValidateAttestationError::HandshakeError {
                description: "attestation report invalid".to_string(),
            });
        }
        if chip_id != Some(peer_package.report.chip_id.to_vec()) {
            return Err(ValidateAttestationError::HandshakeError {
                description: "Peer package chip_id does not match chip_id from registry"
                    .to_string(),
            });
        }
        let peer_tls_cert_hash = peer_package.report.report_data;
        let peer_cert_hash = sha2::Sha256::digest(peer_tls_certificate.certificate_der.as_slice());
        if &peer_tls_cert_hash.as_slice()[0..32] != peer_cert_hash.as_slice() {
            return Err(ValidateAttestationError::HandshakeError {
                description: "tls certificate sha mismatch".to_string(),
            });
        }
        if measurement != peer_package.report.measurement {
            return Err(ValidateAttestationError::HandshakeError {
                description: "measurement mismatch".to_string(),
            });
        }
        Ok(stream)
    }
}

fn is_report_valid(report: &AttestationReport, vcek: &X509) -> bool {
    // See https://github.com/AMDESE/sev-tool
    // function Command::validate_guest_report
    // and function sign_verify_message()
    // Ultimately this is rooted in calls to openssl.
    // We could fork and wrap this repo to integrate into Rust or reimplement in Rust.
    //
    // See https://github.com/virtee/sevctl
    // We could adapt this for our purposes.
    //
    // We use the VCEK from the package.
    // We do not validating WRT the PEK since we are not using that chain.
    let raw_report = report as *const _ as *const u8;
    #[allow(unsafe_code)]
    let raw_report_slice = unsafe { std::slice::from_raw_parts(raw_report, 0x2A0) };
    let hash = sha2::Sha384::digest(raw_report_slice);
    let sig = match EcdsaSig::try_from(&report.signature) {
        Ok(sig) => sig,
        Err(_) => return false,
    };
    let vcek = match vcek.public_key() {
        Ok(public_key) => public_key,
        Err(_) => return false,
    };
    let vcek = match vcek.ec_key() {
        Ok(ec_key) => ec_key,
        Err(_) => return false,
    };
    match sig.verify(&hash, &vcek) {
        Err(e) => {
            println!("{:?}", e);
            false
        }
        Ok(result) => {
            println!("result false");
            result
        }
    }
}

fn is_cert_chain_valid(ark: &X509, ask: &X509, vcek: &X509) -> bool {
    // See https://github.com/AMDESE/sev-tool
    // Command::validate_cert_chain
    // This is consistency checking
    // Command::validate_cert_chain_vcek
    // and Command::validate_cert_chain
    let ark_public_key = match ark.public_key() {
        Ok(key) => key,
        Err(_) => {
            return false;
        }
    };
    if ark.verify(&ark_public_key).is_err() {
        return false;
    }
    if ask.verify(&ark_public_key).is_err() {
        return false;
    }
    let ask_public_key = match ask.public_key() {
        Ok(key) => key,
        Err(_) => {
            return false;
        }
    };
    if vcek.verify(&ask_public_key).is_err() {
        return false;
    }
    true
}

async fn read_into_buffer<T: AsyncRead + Unpin>(
    reader: &mut T,
    buf: &mut [u8],
) -> Result<(), ValidateAttestationError> {
    match reader.read_exact(buf).await {
        Ok(_) => Ok(()),
        Err(_) => Err(ValidateAttestationError::HandshakeError {
            description: "read error".to_string(),
        }),
    }
}

pub fn get_chip_id() -> Result<Vec<u8>, SnpError> {
    // Check if /dev/sev-guest exists
    let sev_guest_device = Path::new("/dev/sev-guest");
    if !sev_guest_device.exists() {
        return Err(SnpError::SnpNotEnabled {
            description: "/dev/sev-guest does not exist. Snp is not enabled on this Guest".into(),
        });
    }

    let mut guest_firmware =
        sev::firmware::guest::Firmware::open().map_err(|error| SnpError::FirmwareError {
            description: format!("unable to open sev guest firmware: {}", error),
        })?;

    let report = guest_firmware
        .get_report(None, None, Some(0))
        .map_err(|error| SnpError::ReportError {
            description: format!("unable to fetch snp report: {}", error),
        })?;

    Ok(report.chip_id.to_vec())
}

#[cfg(test)]
mod test {
    use super::*;
    use assert_matches::assert_matches;

    static ARK_PEM: &[u8] = include_bytes!("data/ark.pem");
    static ASK_PEM: &[u8] = include_bytes!("data/ask_milan.pem");
    static VCEK_PEM: &[u8] = include_bytes!("data/vcek_test.pem");
    static ATTESTATION_REPORT: &[u8] = include_bytes!("data/report.bin");

    #[test]
    fn test_is_cert_chain_valid() {
        let ark = openssl::x509::X509::from_pem(ARK_PEM).expect("invalid ark PEM");
        let ask = openssl::x509::X509::from_pem(ASK_PEM).expect("invalid ask PEM");
        let vcek = openssl::x509::X509::from_pem(VCEK_PEM).expect("invalid vcek PEM");
        assert!(is_cert_chain_valid(&ark, &ask, &vcek));
    }

    #[test]
    fn test_not_is_cert_chain_valid() {
        let ark = openssl::x509::X509::from_pem(ARK_PEM).expect("invalid ark PEM");
        let ask = openssl::x509::X509::from_pem(ASK_PEM).expect("invalid ask PEM");
        let vcek = openssl::x509::X509::from_pem(VCEK_PEM).expect("invalid vcek PEM");
        // Argument order wrong!
        assert!(!is_cert_chain_valid(&vcek, &ask, &ark));
    }

    #[test]
    fn test_is_report_valid() {
        let vcek = openssl::x509::X509::from_pem(VCEK_PEM).expect("invalid vcek PEM");
        let attestation_report: AttestationReport =
            unsafe { std::ptr::read(ATTESTATION_REPORT.as_ptr() as *const _) };
        assert!(is_report_valid(&attestation_report, &vcek));
    }

    #[test]
    fn test_not_is_report_valid() {
        let vcek = openssl::x509::X509::from_pem(VCEK_PEM).expect("invalid vcek PEM");
        let attestation_report = AttestationReport::default();
        assert!(!is_report_valid(&attestation_report, &vcek));
    }

    #[test]
    fn test_get_chip_id_snp_not_enabled_fails() {
        assert_matches!(get_chip_id(), Err(SnpError::SnpNotEnabled { description })
        if description.contains("Snp is not enabled on this Guest"));
    }
}
