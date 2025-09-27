module 0x0::registry {
    use std::vector;
    use sui::object::UID;
    use sui::object;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use sui::event;

    const E_NOT_ADMIN: u64 = 1;
    const E_ISSUER_EXISTS: u64 = 2;
    const E_ISSUER_UNKNOWN: u64 = 3;
    const E_ALREADY_REVOKED: u64 = 4;

    // Liste des émetteurs autorisés
    public struct Issuers has key, store {
        id: UID,
        admins: vector<address>,
        addrs: vector<address>,
    }

    // Événements
    public struct IssuerAdded has copy, drop, store {
        addr: address
    }

    // Initialise le registre des émetteurs
    public entry fun init_registry(initial_admin: address, ctx: &mut TxContext, ) {
        let registry = Issuers {
            id: object::new(ctx),
            admins: vector::singleton(initial_admin),
            addrs: vector::empty<address>(),
        };
        let sender = sender(ctx);
        transfer::transfer(registry, sender);
    }

    // Ajoute une adresse d’émetteur autorisé
    public fun add_issuer(reg: &mut Issuers, admin: address, new_issuer: address) {
        assert!(contains(&reg.admins, &admin), E_NOT_ADMIN);
        assert!(!contains(&reg.addrs, &new_issuer), E_ISSUER_EXISTS);
        vector::push_back(&mut reg.addrs, new_issuer);
        event::emit(IssuerAdded { addr: new_issuer });
    }

    // Supprime un émetteur
    public fun remove_issuer(reg: &mut Issuers, admin: address, issuer: address) {
        assert!(contains(&reg.admins, &admin), E_NOT_ADMIN);
        remove(&mut reg.addrs, &issuer);
    }

    // Fonction appelée par le module `diploma`
    public fun is_authorized_issuer(reg: &Issuers, issuer: &address): bool {
        contains(&reg.addrs, issuer)
    }

    // Helpers internes
    fun contains(vec: &vector<address>, a: &address): bool {
        let mut i = 0;
        let len = vector::length(vec);
        while (i < len) {
            if (vector::borrow(vec, i) == a) return true;
            i = i + 1;
        };
        false
    }

    fun remove(vec: &mut vector<address>, a: &address) {
        let mut i = 0;
        let len = vector::length(vec);
        while (i < len) {
            if (vector::borrow(vec, i) == a) {
                vector::swap_remove(vec, i);
                return;
            };
            i = i + 1;
        };
    }
}