use clap::{crate_authors, Parser};

#[derive(Parser, Debug)]
#[clap(author=crate_authors!(), version, about, name = "oh nana what's my name")]
/// What it do baby
pub(crate) struct Options {
    /// Verbosity
    #[arg(short, long, action = clap::ArgAction::Count)]
    pub(crate) verbosity: u8,
}
