#[starknet::contract]
mod Account {
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::storage::StorageMap;
    use starknet::storage_access::StorageMapReadAccess;
    use starknet::storage_access::StorageMapWriteAccess;
    use starknet::call_contract_syscall::CallResultTrait;
    use starknet::call_contract_syscall::CallContext;
    use starknet::call_contract_syscall::call_contract_syscall;
    use starknet::call_contract_syscall::CallResultTraitImpl;
    use starknet::call_contract_syscall::CallResultTrait;

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

    #[storage]
    struct Storage {
        owner: StorageMap<(), ContractAddress>,
        nonce: StorageMap<(), u64>,
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
        self.owner.write((), owner);
        self.nonce.write((), 0);
    }

    #[external(v0)]
    impl AccountImpl of IAccount<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self.owner.read(())
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
