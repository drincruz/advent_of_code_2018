use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> std::io::Result<()> {
    let mut file = File::open("day01.txt")?;
    let mut lines_iter = BufReader::new(file).lines().map(|l| l.unwrap());
    let mut frequency = 0;
    for line in lines_iter {
        let mut my_int = line.parse::<i32>().unwrap();
        frequency += my_int;
        println!("frequency: {:?}", frequency);
    }
    Ok(())
}
