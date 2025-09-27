module 0x0::diploma {
    use std::vector;
    use sui::object::UID;
    use sui::object;
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::event;

    use 0x0::registry;
    use 0x0::registry::Issuers;

    const E_ISSUER_UNKNOWN: u64 = 3;
    const E_ALREADY_REVOKED: u64 = 4;
    const E_NOT_ADMIN: u64 = 1;

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
    }

    public fun mint_diploma(
        reg: &Issuers,
        issuer: address,
        recipient: address,
        degree_hash: vector<u8>,
        metadata: DiplomaMetadata,
        ctx: &mut TxContext
    ) {
        assert!(registry::is_authorized_issuer(reg, &issuer), E_ISSUER_UNKNOWN);

        let diploma = Diploma {
            id: object::new(ctx),
            issuer,
            recipient,
            degree_hash,
            metadata,
            revoked: false,
        };

        transfer::transfer(diploma, recipient);
        event::emit(DiplomaMinted { issuer, recipient });
    }

    public fun revoke_diploma(d: &mut Diploma, issuer: address) {
        assert!(d.issuer == issuer, E_NOT_ADMIN);
        assert!(!d.revoked, E_ALREADY_REVOKED);
        d.revoked = true;
        event::emit(DiplomaRevoked { issuer, recipient: d.recipient });
    }

    /// Return true if this diploma belongs to the given address
    public fun is_owned_by(d: &Diploma, owner: address): bool {
        d.recipient == owner
}

    public entry fun mint_diploma_entry(
        reg: &Issuers,
        issuer: address,
        recipient: address,
        degree_hash: vector<u8>,
        degree_name: vector<u8>,
        institution_name: vector<u8>,
        graduation_year: u64,
        ctx: &mut TxContext
    ) {
        let metadata = DiplomaMetadata {
            degree_name,
            institution_name,
            graduation_year,
        };

        mint_diploma(reg, issuer, recipient, degree_hash, metadata, ctx);
    }
}