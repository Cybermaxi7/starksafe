use starknet::ContractAddress;
use starknet::testing::{set_contract_address, start_prank, stop_prank};
use starknet::testing::set_caller_address;
use starknet::testing::set_nonce;
use starknet::testing::get_nonce;

use starksafe::account::{
    Account,
    IAccountDispatcher,
    IAccountDispatcherTrait,
};

// Helper function to create a new contract address
fn new_contract_address(addr: u128) -> ContractAddress {
    addr.try_into().unwrap()
}

// Helper function to deploy an account contract
fn setup_account(owner: ContractAddress, contract_address: ContractAddress) -> IAccountDispatcher {
    set_contract_address(contract_address);
    set_nonce(contract_address, 0);
    
    // Deploy the account contract
    let _account = Account::deploy(@contract_address, owner);
    
    // Create a dispatcher for the account
    IAccountDispatcher { contract_address }
}

#[test]
fn test_initialization() {
    // Setup test environment
    let owner = new_contract_address(12345);
    let contract_address = new_contract_address(1);
    
    // Deploy the account and get dispatcher
    let dispatcher = setup_account(owner, contract_address);
    
    // Test that the owner is set correctly
    assert(dispatcher.owner() == owner, 'Incorrect owner');
    
    // Test that the initial nonce is 0
    assert(get_nonce(contract_address) == 0, 'Initial nonce should be 0');
}

#[test]
fn test_transfer_ownership() {
    // Setup test environment
    let owner = new_contract_address(12345);
    let new_owner = new_contract_address(67890);
    let contract_address = new_contract_address(1);
    
    // Deploy the account and get dispatcher
    let dispatcher = setup_account(owner, contract_address);
    
    // Set the caller to the owner
    start_prank(owner);
    
    // Transfer ownership
    dispatcher.transfer_ownership(new_owner);
    
    // Clean up
    stop_prank();
    
    // Verify the new owner
    assert(dispatcher.owner() == new_owner, 'Ownership not transferred');
    
    // Verify the original owner is no longer the owner
    assert(dispatcher.owner() != owner, 'Original owner is still set');
}

#[test]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_only_owner_can_transfer_ownership() {
    // Setup test environment
    let owner = new_contract_address(12345);
    let not_owner = new_contract_address(67890);
    let new_owner = new_contract_address(98765);
    let contract_address = new_contract_address(1);
    
    // Deploy the account and get dispatcher
    let dispatcher = setup_account(owner, contract_address);
    
    // Set the caller to a non-owner
    start_prank(not_owner);
    
    // Try to transfer ownership (should panic)
    dispatcher.transfer_ownership(new_owner);
}

#[test]
fn test_execute() {
    // Setup test environment
    let owner = new_contract_address(12345);
    let contract_address = new_contract_address(1);
    
    // Deploy the account and get dispatcher
    let dispatcher = setup_account(owner, contract_address);
    
    // Create a mock contract to call
    let mock_contract = new_contract_address(67890);
    let selector = 123;
    let calldata = array![1, 2];
    
    // Set the caller to the owner
    start_prank(owner);
    
    // Execute the transaction
    let result = dispatcher.execute(mock_contract, selector, calldata);
    
    // Clean up
    stop_prank();
    
    // Verify the transaction was executed (in a real test, we'd check the state changes)
    assert(result.len() == 0, 'Unexpected return value');
    
    // Verify the nonce was incremented
    assert(get_nonce(contract_address) == 1, 'Nonce was not incremented');
}

#[test]
fn test_nonce_increments_on_execute() {
    // Setup test environment
    let owner = new_contract_address(12345);
    let contract_address = new_contract_address(1);
    
    // Deploy the account and get dispatcher
    let dispatcher = setup_account(owner, contract_address);
    
    // Create a mock contract to call
    let mock_contract = new_contract_address(67890);
    let selector = 123;
    
    // Set the caller to the owner
    start_prank(owner);
    
    // Execute multiple transactions and check nonce increments
    for i in 0..3 {
        let current_nonce = get_nonce(contract_address);
        assert(current_nonce == i, 'Incorrect nonce before execution');
        
        dispatcher.execute(mock_contract, selector, array![]);
        
        let new_nonce = get_nonce(contract_address);
        assert(new_nonce == i + 1, 'Nonce did not increment correctly');
    }
    
    stop_prank();
    
    // Verify final nonce value
    assert(get_nonce(contract_address) == 3, 'Final nonce should be 3');
}

#[test]
fn test_events_are_emitted() {
    // Setup test environment
    let owner = new_contract_address(12345);
    let new_owner = new_contract_address(67890);
    let contract_address = new_contract_address(1);
    
    // Deploy the account and get dispatcher
    let dispatcher = setup_account(owner, contract_address);
    
    // Set the caller to the owner
    start_prank(owner);
    
    // Test ownership transfer event
    expect_events(
        emit(contract_address, Event::OwnershipTransferred(owner, new_owner))
    );
    dispatcher.transfer_ownership(new_owner);
    
    // Test transaction execution event
    let mock_contract = new_contract_address(98765);
    let selector = 456;
    let calldata = array![3, 4];
    
    expect_events(
        emit(contract_address, Event::TransactionExecuted(mock_contract, selector, calldata.span().unbox()))
    );
    dispatcher.execute(mock_contract, selector, calldata);
    
    stop_prank();
}

#[test]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_only_owner_can_execute() {
    // Setup test environment
    let owner = new_contract_address(12345);
    let not_owner = new_contract_address(67890);
    let contract_address = new_contract_address(1);
    
    // Deploy the account and get dispatcher
    let dispatcher = setup_account(owner, contract_address);
    
    // Set the caller to a non-owner
    start_prank(not_owner);
    
    // Try to execute a transaction (should panic)
    let to = new_contract_address(123);
    let selector = 456;
    
    dispatcher.execute(to, selector, array![]);
}
