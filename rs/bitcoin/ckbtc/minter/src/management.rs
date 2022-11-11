//! This module contains async functions for interacting with the management canister.

use crate::tx;
use candid::{CandidType, Principal};
use ic_btc_types::{
    Address, GetCurrentFeePercentilesRequest, GetUtxosRequest, GetUtxosResponse,
    MillisatoshiPerByte, Network, SendTransactionRequest, Utxo, UtxosFilterInRequest,
};
use ic_cdk::api::call::RejectionCode;
use ic_ic00_types::{EcdsaCurve, EcdsaKeyId, SignWithECDSAArgs, SignWithECDSAReply};
use serde::de::DeserializeOwned;
use std::fmt;

/// Represents an error from a management canister call, such as
/// `sign_with_ecdsa` or `bitcoin_send_transaction`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CallError {
    method: String,
    reason: Reason,
}

impl CallError {
    /// Returns the name of the method that resulted in this error.
    pub fn method(&self) -> &str {
        &self.method
    }

    /// Returns the failure reason.
    pub fn reason(&self) -> &Reason {
        &self.reason
    }
}

impl fmt::Display for CallError {
    fn fmt(&self, fmt: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            fmt,
            "management call '{}' failed: {}",
            self.method, self.reason
        )
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
/// The reason for the management call failure.
pub enum Reason {
    /// Failed to send a signature request because the local output queue is
    /// full.
    QueueIsFull,
    /// The canister does not have enough cycles to submit the request.
    OutOfCycles,
    /// The management canister rejected the signature request (not enough
    /// cycles, the ECDSA subnet is overloaded, etc.).
    Rejected(String),
}

impl fmt::Display for Reason {
    fn fmt(&self, fmt: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::QueueIsFull => write!(fmt, "the canister queue is full"),
            Self::OutOfCycles => write!(fmt, "the canister is out of cycles"),
            Self::Rejected(msg) => {
                write!(fmt, "the management canister rejected the call: {}", msg)
            }
        }
    }
}

impl Reason {
    fn from_reject(reject_code: RejectionCode, reject_message: String) -> Self {
        match reject_code {
            RejectionCode::SysTransient => Self::QueueIsFull,
            RejectionCode::CanisterError => Self::OutOfCycles,
            RejectionCode::CanisterReject => Self::Rejected(reject_message),
            _ => Self::QueueIsFull,
        }
    }
}

async fn call<I, O>(method: &str, payment: u64, input: &I) -> Result<O, CallError>
where
    I: CandidType,
    O: CandidType + DeserializeOwned,
{
    let res: Result<(O,), _> = ic_cdk::api::call::call_with_payment(
        Principal::management_canister(),
        method,
        (input,),
        payment,
    )
    .await;

    match res {
        Ok((output,)) => Ok(output),
        Err((code, msg)) => Err(CallError {
            method: method.to_string(),
            reason: Reason::from_reject(code, msg),
        }),
    }
}

/// Fetches the full list of UTXOs for the specified address.
pub async fn get_utxos(
    network: Network,
    address: &Address,
    min_confirmations: u32,
) -> Result<Vec<Utxo>, CallError> {
    const GET_UTXOS_COST_CYCLES: u64 = 100_000_000;

    // Calls "bitcoin_get_utxos" method with the specified argument on the
    // management canister.
    async fn bitcoin_get_utxos(req: &GetUtxosRequest) -> Result<GetUtxosResponse, CallError> {
        call("bitcoin_get_utxos", GET_UTXOS_COST_CYCLES, req).await
    }

    let mut response = bitcoin_get_utxos(&GetUtxosRequest {
        address: address.to_string(),
        network: network.into(),
        filter: Some(UtxosFilterInRequest::MinConfirmations(min_confirmations)),
    })
    .await?;

    let mut utxos = std::mem::take(&mut response.utxos);

    // Continue fetching until there are no more pages.
    while let Some(page) = response.next_page {
        response = bitcoin_get_utxos(&GetUtxosRequest {
            address: address.to_string(),
            network: network.into(),
            filter: Some(UtxosFilterInRequest::Page(page)),
        })
        .await?;

        utxos.append(&mut response.utxos);
    }

    Ok(utxos)
}

/// Returns the current fee percentiles on the bitcoin network.
pub async fn get_current_fees(network: Network) -> Result<Vec<MillisatoshiPerByte>, CallError> {
    const GET_CURRENT_FEE_PERCENTILES_COST_CYCLES: u64 = 100 * 1_000_000;

    call(
        "bitcoin_get_current_fee_percentiles",
        GET_CURRENT_FEE_PERCENTILES_COST_CYCLES,
        &GetCurrentFeePercentilesRequest {
            network: network.into(),
        },
    )
    .await
}

/// Sends the transaction to the network the management canister interacts with.
pub async fn send_transaction(
    transaction: &tx::SignedTransaction,
    network: Network,
) -> Result<(), CallError> {
    const SEND_TRANSACTION_BASE_COST_CYCLES: u64 = 5 * 1_000_000_000;
    const SEND_TRANSACTION_COST_CYCLES_PER_BYTE: u64 = 20 * 1_000_000;

    let tx_bytes = transaction.serialize();

    let transaction_cost_cycles = SEND_TRANSACTION_BASE_COST_CYCLES
        + (tx_bytes.len() as u64) * SEND_TRANSACTION_COST_CYCLES_PER_BYTE;

    call(
        "bitcoin_send_transaction",
        transaction_cost_cycles,
        &SendTransactionRequest {
            transaction: tx_bytes,
            network: network.into(),
        },
    )
    .await
}

/// Signs a message hash using the tECDSA API.
pub async fn sign_with_ecdsa(
    key_name: String,
    derivation_path: Vec<Vec<u8>>,
    message_hash: [u8; 32],
) -> Result<Vec<u8>, CallError> {
    const CYCLES_PER_SIGNATURE: u64 = 10_000_000_000;

    let reply: SignWithECDSAReply = call(
        "sign_with_ecdsa",
        CYCLES_PER_SIGNATURE,
        &SignWithECDSAArgs {
            message_hash,
            derivation_path,
            key_id: EcdsaKeyId {
                curve: EcdsaCurve::Secp256k1,
                name: key_name.clone(),
            },
        },
    )
    .await?;
    Ok(reply.signature)
}
