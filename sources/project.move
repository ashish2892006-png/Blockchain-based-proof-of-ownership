module MyModule::ProofOfOwnership {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::string::{Self, String};
    
    /// Struct representing ownership of an asset
    struct Asset has store, key {
        name: String,           // Name/description of the asset
        owner: address,         // Current owner of the asset
        created_at: u64,        // Timestamp when ownership was first registered
        last_transferred: u64,  // Timestamp of last ownership transfer
    }
    
    /// Function to register ownership of a new asset
    public fun register_asset(owner: &signer, asset_name: String) {
        let owner_address = signer::address_of(owner);
        let current_time = timestamp::now_seconds();
        
        let asset = Asset {
            name: asset_name,
            owner: owner_address,
            created_at: current_time,
            last_transferred: current_time,
        };
        
        move_to(owner, asset);
    }
    
    /// Function to transfer ownership of an asset to a new owner
    public fun transfer_ownership(
        current_owner: &signer, 
        new_owner: address, 
        asset_owner_address: address
    ) acquires Asset {
        let current_owner_address = signer::address_of(current_owner);
        let asset = borrow_global_mut<Asset>(asset_owner_address);
        
        // Verify that the signer is the current owner
        assert!(asset.owner == current_owner_address, 1);
        
        // Transfer ownership
        asset.owner = new_owner;
        asset.last_transferred = timestamp::now_seconds();
    }
}