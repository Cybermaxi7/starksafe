use starknet::ContractAddress;
use starknet::get_caller_address;

#[starknet::interface]
pub trait IAccount<T> {
    fn execute(
        self: @T,
        to: ContractAddress,
        selector: u32,
        calldata: Array<u128>,
    ) -> Array<u128>;

    fn transfer_ownership(ref self: T, new_owner: ContractAddress);
    
    fn owner(self: @T) -> ContractAddress;
}

#[starknet::contract]
mod Account {
    use super::IAccount;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::storage::StorageAccess;
    use starknet::storage::StoragePointerReadAccess;
    use starknet::storage::StoragePointerWriteAccess;



    #[storage]
    struct Storage {
        owner: ContractAddress,
        nonce: u64,
    }

    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TransactionExecuted: TransactionExecuted,
        OwnershipTransferred: OwnershipTransferred,
    }
    
    #[derive(Drop, starknet::Event)]
    struct TransactionExecuted {
        to: ContractAddress,
        selector: u32,
        calldata: Span<u128>,
    }
    
    #[derive(Drop, starknet::Event)]
    struct OwnershipTransferred {
        previous_owner: ContractAddress,
        new_owner: ContractAddress,
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

        fn execute(
            self: @ContractState,
            to: ContractAddress,
            selector: u32,
            calldata: Array<u128>,
        ) -> Array<u128> {
            // Only the owner can execute transactions
            let caller = get_caller_address();
            let owner = self.owner.read();
            assert(caller == owner, 'Caller is not the owner');

            // Increment nonce
            let current_nonce = self.nonce.read();
            self.nonce.write(current_nonce + 1);

            // In a real implementation, we would execute the call here
            // For now, we'll just return an empty array as a placeholder
            
            // Emit event
            self.emit(Event::TransactionExecuted(TransactionExecuted { 
                to, 
                selector, 
                calldata: calldata.span() 
            }));
            
            // Return empty array as placeholder
            ArrayTrait::new()
        }

        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            // Only the owner can transfer ownership
            let caller = get_caller_address();
            let current_owner = self.owner.read();
            assert(caller == current_owner, 'Caller is not the owner');

            // Emit event
            self.emit(Event::OwnershipTransferred(OwnershipTransferred {
                previous_owner: current_owner,
                new_owner,
            }));

            // Update owner
            self.owner.write(new_owner);
            
            // Update nonce
            let current_nonce = self.nonce.read();
            self.nonce.write(current_nonce + 1);
        }
    }
}

// Helper trait for call result
#[starknet::interface]
trait IAccount<T> {
    fn execute(
        self: @T,
        to: ContractAddress,
        selector: felt252,
        calldata: Array<felt252>,
    ) -> Array<felt252>;
    
    fn transfer_ownership(ref self: T, new_owner: ContractAddress);
}
