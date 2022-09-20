extern crate rand;
extern crate zstd;
use std::io::Write;

use rand::Rng;

fn main() -> std::io::Result<()> {
    let rn = rand::thread_rng().gen_range(38, 45);
    println!("Hello, random: {}", rn);
    println!("ZSTD default compression level: {}", zstd::DEFAULT_COMPRESSION_LEVEL);

    let mut infile = std::fs::File::create("infile")?;
    let mut outfile = std::fs::OpenOptions::new().write(true).create(true).open("outfile")?;
    infile.write_all(b"Hello, random")?;
    let infile1 = std::fs::File::open("infile")?;
    zstd::stream::copy_encode(&infile1, &mut outfile, 0)?;

    // Test linking against OpenSSL
    openssl::init();
    assert!(openssl::version::version().starts_with("OpenSSL "));

    Ok(())
}
