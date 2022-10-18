use std::process::ExitCode;

use anyhow::Result;
use clap::Parser;
use log::LevelFilter;

mod cli;

fn run() -> Result<()> {
    log::info!("hello world");
    Ok(())
}

fn main() -> ExitCode {
    let options = cli::Options::parse();
    let level = match options.verbosity {
        0 => LevelFilter::Warn,
        1 => LevelFilter::Info,
        2 => LevelFilter::Debug,
        _ => LevelFilter::Trace,
    };
    env_logger::Builder::new().filter_level(level).init();

    if let Err(err) = run() {
        log::error!("{err:?}");
        return ExitCode::FAILURE;
    }
    ExitCode::SUCCESS
}
