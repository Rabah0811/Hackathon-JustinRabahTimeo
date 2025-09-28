module sui_attendance::diploma {
    use std::vector;
    use sui::object::UID;
    use sui::object;
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::event;

    use sui_attendance::registry;
    use sui_attendance::registry::Issuers;
    use sui_attendance::registry::MintCap;


    public struct Diploma has key {
        id: UID,
        issuer: address,
        recipient: address,
        degree_hash: vector<u8>,
        metadata: DiplomaMetadata,
        revoked: bool,
    }

    public struct DiplomaMinted has copy, drop, store {
        issuer: address,
        recipient: address,
    }

    public struct DiplomaRevoked has copy, drop, store {
        issuer: address,
        recipient: address,
    }

    public struct DiplomaMetadata has copy, drop, store {
    degree_name: vector<u8>,
    institution_name: vector<u8>,
    graduation_year: u64,
    first_name: vector<u8>,
    last_name: vector<u8>,
    birthday: vector<u8>,
    }

    public fun is_owned_by(d: &Diploma, owner: address): bool {
        d.recipient == owner
    }

    public entry fun mint_diploma_entry(//if metadata is not existing
        reg: &MintCap,
        issuer: address,
        recipient: address,
        degree_hash: vector<u8>,
        degree_name: vector<u8>,
        institution_name: vector<u8>,
        graduation_year: u64,
        first_name: vector<u8>,
        last_name: vector<u8>,
        birthday: vector<u8>,
        ctx: &mut TxContext
    ) {
        let metadata = DiplomaMetadata {
            degree_name,
            institution_name,
            graduation_year,
            first_name,
            last_name,
            birthday,
        };

        mint_diploma(reg, issuer, recipient, degree_hash, metadata, ctx);
    }
}