use eyre::Result;

pub fn add(left: usize, right: usize) -> Result<usize> {
    log::info!("adding");
    Ok(left + right)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2).unwrap();
        assert_eq!(result, 4);
    }
}
