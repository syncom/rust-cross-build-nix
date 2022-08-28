extern crate rand;
use rand::Rng;

fn main() {
    let rn = rand::thread_rng().gen_range(38, 45);
    println!("Hello, random: {}", rn);
}
