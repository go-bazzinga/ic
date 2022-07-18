"""
This module declares all direct rust dependencies.
@generated by workspaceifier
"""

load("@rules_rust//crate_universe:defs.bzl", "crate", "crates_repository", "splicing_config")

def external_crates_repository(name, annotations):
    crates_repository(
        name = name,
        annotations = annotations,
        isolated = True,
        lockfile = "//:Cargo.Bazel.lock",
        cargo_config = "//:bazel/cargo.config",
        packages = {
            "actix-rt": crate.spec(
                version = "^2.2.0",
            ),
            "actix-web": crate.spec(
                version = "^4.0.0-beta.6",
            ),
            "anyhow": crate.spec(
                version = "^1",
            ),
            "arrayvec": crate.spec(
                version = "^0.5.1",
            ),
            "askama": crate.spec(
                version = "^0.11.1",
                features = [
                    "serde-json",
                ],
            ),
            "assert-json-diff": crate.spec(
                version = "^2.0.1",
            ),
            "assert_cmd": crate.spec(
                version = "^0.12",
            ),
            "assert_matches": crate.spec(
                version = "^1.3.0",
            ),
            "async-recursion": crate.spec(
                version = "^0.3.2",
            ),
            "async-socks5": crate.spec(
                version = "^0.5.1",
            ),
            "async-stream": crate.spec(
                version = "^0.3.2",
            ),
            "async-trait": crate.spec(
                version = "^0.1.31",
            ),
            "axum": crate.spec(
                version = "^0.5.1",
            ),
            "backoff": crate.spec(
                version = "^0.3.0",
            ),
            "base32": crate.spec(
                version = "^0.4.0",
            ),
            "base64": crate.spec(
                version = "^0.11.0",
            ),
            "bincode": crate.spec(
                version = "^1.2.1",
            ),
            "bindgen": crate.spec(
                version = "^0.59.0",
                default_features = False,
                features = ["runtime"],
            ),
            "bip32": crate.spec(
                version = "^0.4.0",
                features = [
                    "secp256k1",
                ],
            ),
            "bit-vec": crate.spec(
                version = "^0.6.3",
            ),
            "bitcoin": crate.spec(
                version = "^0.28.1",
                features = [
                    "default",
                    "rand",
                    "use-serde",
                ],
            ),
            "bitflags": crate.spec(
                version = "^1.2.1",
            ),
            "bls12_381": crate.spec(
                version = "^0.7.0",
                features = [
                    "alloc",
                    "experimental",
                    "groups",
                    "pairings",
                    "zeroize",
                ],
                default_features = False,
            ),
            "build-info": crate.spec(
                git = "https://github.com/dfinity-lab/build-info",
                rev = "abb2971c5d07a9b40d41a0c84b63a3156f2ff764",
            ),
            "build-info-build": crate.spec(
                git = "https://github.com/dfinity-lab/build-info",
                rev = "abb2971c5d07a9b40d41a0c84b63a3156f2ff764",
            ),
            "byte-unit": crate.spec(
                version = "^4.0.14",
            ),
            "byteorder": crate.spec(
                version = "^1.3.4",
            ),
            "bytes": crate.spec(
                version = "^1.0.1",
            ),
            "candid": crate.spec(
                version = "^0.7.15",
            ),
            "cargo_metadata": crate.spec(
                version = "^0.14.2",
            ),
            "candid_derive": crate.spec(version = "^0.4.5"),
            "cc": crate.spec(
                version = "^1.0",
            ),
            "cfg-if": crate.spec(version = "^0.1.10"),
            "chrono": crate.spec(
                version = "^0.4.19",
            ),
            "ciborium": crate.spec(
                git = "https://github.com/enarx/ciborium",
                rev = "e719537c99b564c3674a56defe53713c702c6f46",
            ),
            "clap": crate.spec(
                version = "^3.1.6",
                features = [
                    "derive",
                ],
            ),
            "colored": crate.spec(
                version = "^2.0.0",
            ),
            "comparable": crate.spec(
                version = "^0.5",
                features = [
                    "derive",
                ],
            ),
            "console": crate.spec(
                version = "^0.11",
            ),
            "crc32fast": crate.spec(
                version = "^1.2.0",
            ),
            "criterion": crate.spec(
                version = "^0.3",
                features = [
                    "html_reports",
                ],
            ),
            "crossbeam": crate.spec(
                version = "^0.8.0",
            ),
            "crossbeam-channel": crate.spec(
                version = "^0.5.0",
            ),
            "csv": crate.spec(
                version = "^1.1",
            ),
            "curve25519-dalek": crate.spec(
                version = "^3.0.2",
            ),
            "cvt": crate.spec(
                version = "^0.1.1",
            ),
            "debug_stub_derive": crate.spec(
                version = "^0.3.0",
            ),
            "derive_more": crate.spec(
                git = "https://github.com/dfinity-lab/derive_more",
                rev = "9f1b894e6fde640da4e9ea71a8fc0e4dd98d01da",
            ),
            "digest": crate.spec(
                version = "^0.9.0",
            ),
            "ed25519-consensus": crate.spec(
                version = "^2.0.1",
            ),
            "ed25519-dalek": crate.spec(
                version = "^1.0.1",
            ),
            "either": crate.spec(
                version = "^1.6",
            ),
            "erased-serde": crate.spec(
                version = "^0.3.11",
            ),
            "escargot": crate.spec(
                version = "^0.5.2",
            ),
            "exec": crate.spec(
                version = "^0.3.1",
            ),
            "eyre": crate.spec(
                version = "^0.6.8",
            ),
            "fast-socks5": crate.spec(
                version = "^0.7.0",
            ),
            "features": crate.spec(
                version = "^0.10.0",
            ),
            "ff": crate.spec(
                version = "^0.12.0",
                features = [
                    "std",
                ],
                default_features = False,
            ),
            "fix-hidden-lifetime-bug": crate.spec(
                version = "^0.2.4",
            ),
            "flate2": crate.spec(
                version = "^1.0.22",
            ),
            "float-cmp": crate.spec(
                version = "^0.9.0",
            ),
            "fs_extra": crate.spec(
                version = "^1.2.0",
            ),
            "futures": crate.spec(
                version = "^0.3.6",
            ),
            "futures-util": crate.spec(
                version = "^0.3.8",
            ),
            "garcon": crate.spec(
                version = "^0.2.3",
            ),
            "getrandom": crate.spec(
                version = "^0.2",
                features = [
                    "custom",
                ],
            ),
            "gflags": crate.spec(
                version = "^0.3.7",
            ),
            "gflags-derive": crate.spec(
                version = "^0.1",
            ),
            "glob": crate.spec(
                version = "^0.3.0",
            ),
            "hashlink": crate.spec(
                version = "^0.8.0",
            ),
            "hex": crate.spec(
                version = "^0.4.3",
                features = [
                    "serde",
                ],
            ),
            "hex-literal": crate.spec(
                version = "^0.2.1",
            ),
            "http": crate.spec(
                version = "^0.2.6",
            ),
            "humantime": crate.spec(
                version = "^2.1.0",
            ),
            "humantime-serde": crate.spec(
                version = "^1.0",
            ),
            "hyper": crate.spec(
                version = "^0.14.18",
                features = [
                    "client",
                    "full",
                    "http1",
                    "http2",
                    "server",
                    "tcp",
                ],
            ),
            "hyper-rustls": crate.spec(
                version = "^0.23.0",
                features = [
                    "webpki-roots",
                ],
            ),
            "hyper-socks2": crate.spec(
                version = "^0.6.0",
            ),
            "hyper-tls": crate.spec(
                version = "^0.5.0",
            ),
            "iai": crate.spec(
                version = "^0.1",
            ),
            "ic-agent": crate.spec(
                version = "^0.20.0",
            ),
            "ic-cdk": crate.spec(
                version = "^0.5",
                default_features = False,
            ),
            "ic-cdk-macros": crate.spec(
                version = "^0.5",
            ),
            "ic-certified-map": crate.spec(
                git = "https://github.com/dfinity/cdk-rs",
                rev = "2112e912e156b271389a51777680de542bb43980",
            ),
            "ic-identity-hsm": crate.spec(
                version = "=0.20.0",
            ),
            "ic-ledger-types": crate.spec(
                version = "^0.1.1",
            ),
            "ic-utils": crate.spec(
                version = "^0.20.0",
            ),
            "indicatif": crate.spec(
                version = "^0.15",
                features = [
                    "improved_unicode",
                ],
            ),
            "indoc": crate.spec(
                version = "^1.0.6",
            ),
            "insta": crate.spec(
                version = "^1.8.0",
            ),
            "intmap": crate.spec(
                version = "^1.1.0",
                features = ["serde"],
            ),
            "ipnet": crate.spec(
                version = "^2.5.0",
            ),
            "itertools": crate.spec(
                version = "^0.10.0",
            ),
            "jemalloc-ctl": crate.spec(
                version = "^0.3.3",
            ),
            "jemallocator": crate.spec(
                version = "^0.3.2",
            ),
            "json5": crate.spec(
                version = "^0.4.1",
            ),
            "k256": crate.spec(
                version = "^0.11.2",
                features = [
                    "arithmetic",
                    "ecdsa",
                ],
                default_features = False,
            ),
            "lazy_static": crate.spec(
                version = "^1.4.0",
            ),
            "leaky-bucket": crate.spec(
                version = "^0.11.0",
            ),
            "leb128": crate.spec(
                version = "^0.2.5",
            ),
            "libc": crate.spec(
                version = "^0.2.91",
            ),
            "libflate": crate.spec(
                version = "^1.1.2",
            ),
            "libsecp256k1": crate.spec(
                version = "^0.5.0",
            ),
            "linked-hash-map": crate.spec(
                version = "^0.5.3",
            ),
            "log": crate.spec(
                version = "^0.4.14",
            ),
            "log4rs": crate.spec(
                version = "^1.1.1",
            ),
            "lru": crate.spec(
                version = "^0.7.1",
                default_features = False,
            ),
            "maplit": crate.spec(
                version = "^1.0.2",
            ),
            "mersenne_twister": crate.spec(
                version = "^1.1.1",
            ),
            "mio": crate.spec(
                version = "^0.7",
                features = [
                    "os-ext",
                    "os-poll",
                    "pipe",
                ],
            ),
            "miracl_core_bls12381": crate.spec(
                version = "^4.1.2",
            ),
            "mockall": crate.spec(
                version = "^0.11.1",
            ),
            "mockall-0_7_2": crate.spec(
                package = "mockall",
                version = "^0.7.2",
            ),
            "native-tls": crate.spec(
                version = "^0.2.7",
                features = [
                    "alpn",
                ],
            ),
            "nix": crate.spec(
                version = "^0.23.0",
            ),
            "nonblock": crate.spec(
                version = "^0.1.0",
            ),
            "notify": crate.spec(
                version = "^4.0.12",
            ),
            "num": crate.spec(
                version = "^0.4.0",
            ),
            "num-bigint": crate.spec(
                version = "^0.4.0",
            ),
            "num-bigint-dig": crate.spec(
                version = "0.8",
                features = ["prime"],
            ),
            "num-integer": crate.spec(
                version = "^0.1.41",
            ),
            "num-rational": crate.spec(
                version = "^0.2.2",
            ),
            "num-traits": crate.spec(
                version = "^0.2.12",
                features = [
                    "libm",
                ],
                default_features = False,
            ),
            "num_cpus": crate.spec(
                version = "^1.13.1",
            ),
            "once_cell": crate.spec(
                version = "^1.8",
            ),
            "openssh-keys": crate.spec(
                version = "^0.5.0",
            ),
            "openssl": crate.spec(
                version = "^0.10.29",
            ),
            "opentelemetry": crate.spec(
                version = "^0.17.0",
            ),
            "opentelemetry-prometheus": crate.spec(
                version = "^0.10.0",
            ),
            "p256": crate.spec(
                version = "^0.10",
                features = [
                    "arithmetic",
                ],
                default_features = False,
            ),
            "pairing": crate.spec(
                version = "^0.22",
            ),
            "parity-wasm": crate.spec(
                version = "^0.42.2",
                features = [
                    "bulk",
                    "multi_value",
                    "std",
                ],
            ),
            "parking_lot": crate.spec(
                version = "^0.11.1",
            ),
            "parse_int": crate.spec(
                version = "^0.4.0",
            ),
            "paste": crate.spec(
                version = "^1.0.0",
            ),
            "pathdiff": crate.spec(
                version = "^0.2.1",
            ),
            "pem": crate.spec(
                version = "^1.0.1",
            ),
            "pico-args": crate.spec(
                version = "^0.3",
            ),
            "pkg-config": crate.spec(
                version = "^0.3",
            ),
            "pprof": crate.spec(
                version = "^0.9.1",
                features = [
                    "backtrace-rs",
                    "flamegraph",
                    "prost-codec",
                ],
                default_features = False,
            ),
            "predicates": crate.spec(
                version = "^1.0.1",
            ),
            "pretty-bytes": crate.spec(
                version = "^0.2.2",
            ),
            "pretty_assertions": crate.spec(
                version = "^0.6.1",
            ),
            "proc-macro2": crate.spec(
                version = "^1.0",
            ),
            "procfs": crate.spec(
                version = "^0.9",
                default_features = False,
            ),
            "prometheus": crate.spec(
                version = "^0.13.0",
                features = [
                    "process",
                ],
            ),
            "proptest": crate.spec(
                version = "^0.9.4",
            ),
            "proptest-derive": crate.spec(
                version = "^0.1.0",
            ),
            "prost": crate.spec(
                version = "^0.10.4",
            ),
            "prost-build": crate.spec(
                version = "^0.10.4",
            ),
            "prost-derive": crate.spec(
                version = "^0.10",
            ),
            "quickcheck": crate.spec(
                version = "^1.0.3",
            ),
            "quote": crate.spec(
                version = "^1.0",
            ),
            "rand-0_4_6": crate.spec(
                package = "rand",
                version = "^0.4.6",
            ),
            "rand-0_7_3": crate.spec(
                package = "rand",
                version = "^0.7.3",
            ),
            "rand-0_8_4": crate.spec(
                package = "rand",
                version = "^0.8.4",
            ),
            "rand_chacha": crate.spec(version = "^0.2.2"),
            "rand_chacha-0_3_1": crate.spec(
                package = "rand_chacha",
                version = "^0.3.1",
            ),
            "rand_core": crate.spec(
                version = "^0.5.1",
            ),
            "rand_distr": crate.spec(
                version = "^0.3.0",
            ),
            "rand_pcg": crate.spec(
                version = "^0.3.1",
            ),
            "randomkit": crate.spec(
                version = "^0.1.1",
            ),
            "rayon": crate.spec(
                version = "^1.5.1",
            ),
            "regex": crate.spec(
                version = "^1.3.9",
            ),
            "reqwest": crate.spec(
                version = "^0.11.1",
                features = [
                    "blocking",
                    "json",
                    "multipart",
                    "native-tls",
                    "stream",
                ],
            ),
            "retain_mut": crate.spec(
                version = "^0.1",
            ),
            "ring": crate.spec(
                version = "^0.16.11",
                features = [
                    "std",
                ],
            ),
            "rocksdb": crate.spec(
                version = "^0.15.0",
            ),
            "rsa": crate.spec(
                version = "^0.4.0",
            ),
            "rusqlite": crate.spec(
                version = "^0.25.3",
            ),
            "rustc-hash": crate.spec(
                version = "^1.1.0",
            ),
            "rustls": crate.spec(
                version = "^0.20.4",
            ),
            "rustversion": crate.spec(
                version = "^1.0",
            ),
            "rusty-fork": crate.spec(
                version = "^0.3.0",
            ),
            "scoped_threadpool": crate.spec(
                version = "0.1.*",
            ),
            "secp256k1": crate.spec(
                version = "^0.20.3",
            ),
            "semver": crate.spec(
                version = "^1.0.9",
                features = [
                    "serde",
                ],
            ),
            "serde": crate.spec(
                version = "^1.0.99",
                features = [
                    "derive",
                ],
                default_features = False,
            ),
            "serde-bytes-repr": crate.spec(
                version = "^0.1.5",
            ),
            "serde_bytes": crate.spec(
                version = "^0.11",
            ),
            "serde_cbor": crate.spec(
                version = "^0.11.2",
            ),
            "serde_derive": crate.spec(
                version = "^1.0",
            ),
            "serde_json": crate.spec(
                version = "^1.0.40",
            ),
            "serde_millis": crate.spec(
                version = "^0.1",
            ),
            "serde_with": crate.spec(
                version = "^1.6.2",
            ),
            "serial_test": crate.spec(
                version = "^0.5.0",
            ),
            "sha2": crate.spec(
                version = "^0.9.1",
            ),
            "sha3": crate.spec(
                version = "^0.9.1",
            ),
            "signal-hook": crate.spec(
                version = "^0.3.6",
                features = [
                    "iterator",
                ],
            ),
            "signal-hook-mio": crate.spec(
                version = "^0.2.0",
                features = [
                    "support-v0_7",
                ],
            ),
            "simple_asn1": crate.spec(
                version = "^0.5.4",
            ),
            "slog": crate.spec(
                version = "^2.5.2",
                features = [
                    "max_level_trace",
                    "nested-values",
                    "release_max_level_debug",
                    "release_max_level_trace",
                ],
            ),
            "slog-async": crate.spec(
                version = "^2.5",
                features = [
                    "nested-values",
                ],
            ),
            "slog-envlogger": crate.spec(
                version = "^2.2.0",
            ),
            "slog-json": crate.spec(
                version = "^2.3",
                features = [
                    "nested-values",
                ],
            ),
            "slog-scope": crate.spec(
                version = "^4.1.2",
            ),
            "slog-term": crate.spec(
                version = "^2.6.0",
            ),
            "slog_derive": crate.spec(
                version = "^0.2.0",
            ),
            "socket2": crate.spec(
                version = "^0.3.19",
                features = [
                    "reuseport",
                ],
            ),
            "ssh2": crate.spec(
                git = "https://github.com/dfinity-lab/ssh2-rs",
                rev = "f842906afaa2443206b8365d51950ed3ef85c940",
            ),
            "static_assertions": crate.spec(
                version = "^0.3.4",
            ),
            "statrs": crate.spec(
                version = "^0.15.0",
            ),
            "strum": crate.spec(
                version = "^0.23.0",
                features = [
                    "derive",
                ],
            ),
            "strum_macros": crate.spec(
                version = "^0.23.0",
            ),
            "substring": crate.spec(
                version = "^1.4.5",
            ),
            "subtle": crate.spec(
                version = "^2.4",
            ),
            "syn": crate.spec(
                version = "^1.0",
                features = [
                    "fold",
                    "full",
                ],
            ),
            "tar": crate.spec(
                version = "^0.4.38",
            ),
            "tarpc": crate.spec(
                version = "^0.27",
                features = [
                    "full",
                ],
            ),
            "tempfile": crate.spec(
                version = "^3.1.0",
            ),
            "tester": crate.spec(
                version = "^0.7.0",
            ),
            "thiserror": crate.spec(
                version = "^1.0",
            ),
            "thread_profiler": crate.spec(
                version = "^0.3",
            ),
            "threadpool": crate.spec(
                version = "^1.8.1",
            ),
            "tiny_http": crate.spec(
                version = "^0.10.0",
            ),
            "tokio": crate.spec(
                version = "^1.15.0",
                features = [
                    "full",
                    "io-util",
                    "macros",
                    "net",
                    "rt",
                    "sync",
                    "time",
                ],
            ),
            "tokio-openssl": crate.spec(
                version = "^0.6.1",
            ),
            "tokio-rustls": crate.spec(
                version = "^0.22.0",
                features = [
                    "dangerous_configuration",
                ],
            ),
            "tokio-serde": crate.spec(
                version = "^0.8",
                features = [
                    "bincode",
                    "json",
                ],
            ),
            "tokio-socks": crate.spec(
                version = "^0.5.1",
            ),
            "tokio-test": crate.spec(
                version = "^0.4.2",
            ),
            "tokio-util": crate.spec(
                version = "^0.6.8",
            ),
            "toml": crate.spec(
                version = "^0.5.9",
            ),
            "tonic": crate.spec(
                version = "^0.7.2",
            ),
            "tonic-build": crate.spec(
                version = "^0.7.2",
            ),
            "tower": crate.spec(
                version = "^0.4.11",
                features = [
                    "buffer",
                    "limit",
                    "load-shed",
                    "steer",
                    "timeout",
                    "util",
                ],
            ),
            "tracing": crate.spec(
                version = "^0.1.34",
            ),
            "tracing-appender": crate.spec(
                version = "^0.2.2",
            ),
            "tracing-subscriber": crate.spec(
                version = "^0.3.11",
                features = [
                    "json",
                ],
            ),
            "url": crate.spec(
                version = "^2.1.1",
                features = [
                    "serde",
                ],
            ),
            "uuid": crate.spec(
                version = "^0.8.1",
                features = [
                    "v4",
                ],
            ),
            "vsock": crate.spec(
                version = "^0.2.6",
            ),
            "wait-timeout": crate.spec(
                version = "^0.2.0",
            ),
            "walkdir": crate.spec(
                version = "^2.3.1",
            ),
            "wasm-bindgen": crate.spec(
                version = "^0.2",
            ),
            "wasmtime": crate.spec(
                version = "^0.37",
                default_features = False,
                features = [
                    "cranelift",
                    "parallel-compilation",
                    "posix-signals-on-macos",
                    "wasm-backtrace",
                ],
            ),
            "wasmtime-environ": crate.spec(
                version = "^0.37",
            ),
            "wasmtime-runtime": crate.spec(
                version = "^0.37",
            ),
            "webpki": crate.spec(
                version = "^0.21.4",
            ),
            "which": crate.spec(
                version = "^4.2.2",
            ),
            "wiremock": crate.spec(
                version = "^0.5.10",
            ),
            "wsl": crate.spec(
                version = "^0.1.0",
            ),
            "wycheproof": crate.spec(
                version = "^0.4",
            ),
            "x509-parser": crate.spec(
                version = "^0.12.0",
            ),
            "yansi": crate.spec(
                version = "^0.5.0",
            ),
            "zeroize": crate.spec(
                version = "^1.4.3",
                features = [
                    "zeroize_derive",
                ],
            ),
        },
        splicing_config = splicing_config(
            resolver_version = "2",
        ),
    )
