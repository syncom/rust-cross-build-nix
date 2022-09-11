extern crate rand;
extern crate zstd;
use rand::Rng;

fn main() {
    let rn = rand::thread_rng().gen_range(38, 45);
    println!("Hello, random: {}", rn);
    println!("ZSTD default compression level: {}", zstd::DEFAULT_COMPRESSION_LEVEL);
}
