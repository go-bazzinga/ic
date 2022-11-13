use clap::Parser;
use ic_backup::{backup_manager::BackupManager, cmd::BackupArgs};
use slog::{o, Drain};

// Here is an example config file:
//
// {
//     "backup_instance": "zh1-spm34",
//     "root_dir": "./backup",
//     "nns_url": "https://smallXYZ.testnet.dfinity.network",
//     "ssh_credentials": "/home/my_user/.ssh/id_ed25519_backup",
//     "slack_token": "ABCD1234"
//     "subnets": [
//       {
//         "subnet_id": "ziu2q-il6zl-3654z-zcdg2-nbtx3-u2ba3-7yzey-flpky-aam7n-x53ip-uqe",
//         "replica_version": "2f844c50765df0833c075b7340ac5f2dd9d5dc21",
//         "nodes_syncing": 5,
//         "sync_period_secs": 1800,
//         "replay_period_secs": 7200
//       },
//       {
//         "subnet_id": "qwzvq-hye2n-7o7ey-gllix-3bgyy-lfopp-q22hm-oaoez-yqtyi-qz64d-vqe",
//         "replica_version": "2f844c50765df0833c075b7340ac5f2dd9d5dc21",
//         "nodes_syncing": 5,
//         "sync_period_secs": 3600,
//         "replay_period_secs": 7200
//       }
//     ]
// }

fn main() {
    // initialize a logger
    let decorator = slog_term::TermDecorator::new().build();
    let drain = slog_term::FullFormat::new(decorator).build().fuse();
    let drain = slog_async::Async::new(drain).build().fuse();
    let log = slog::Logger::root(drain, o!());

    let args = BackupArgs::parse();
    BackupManager::new(args.config_file, log).do_backups();
}
