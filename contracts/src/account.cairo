// Minimal, modern Cairo 2 account contract
use starknet::ContractAddress;
use starknet::get_caller_address;

#[starknet::interface]
pub trait IAccount<T> {
    fn owner(self: @T) -> ContractAddress;
    fn execute(ref self: T, to: ContractAddress, selector: felt252, calldata: Array<felt252>) -> Array<felt252>;
    fn transfer_ownership(ref self: T, new_owner: ContractAddress);
}

#[starknet::contract]
mod Account {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use core::array::ArrayTrait;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::IAccount;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use core::array::ArrayTrait;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        nonce: u64,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.nonce.write(0);
    }

    #[abi(embed_v0)]
    impl AccountImpl of IAccount<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn execute(ref self: ContractState, to: ContractAddress, selector: felt252, calldata: Array<felt252>) -> Array<felt252> {
            // Only the owner can execute transactions
            let caller = get_caller_address();
            let owner = self.owner.read();
            assert(caller == owner, 'Caller is not the owner');

            // Increment nonce
            let current_nonce = self.nonce.read();
            self.nonce.write(current_nonce + 1);

            // Return empty result for now
            ArrayTrait::new()
        }

        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            // Only the owner can transfer ownership
            let caller = get_caller_address();
            let current_owner = self.owner.read();
            assert(caller == current_owner, 'Caller is not the owner');

            // Update owner
            self.owner.write(new_owner);
            // Update nonce
            let current_nonce = self.nonce.read();
            self.nonce.write(current_nonce + 1);
        }
    }
}
