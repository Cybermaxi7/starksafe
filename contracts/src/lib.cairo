//! # Starksafe Account Abstraction
//! 
//! This crate provides an account abstraction implementation for Starknet.

// Re-export the account module
pub mod account;

// For testing
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn it_works() {
        // Simple test to verify the test framework is working
        assert(1 == 1, 'Sanity check');
    }
}
