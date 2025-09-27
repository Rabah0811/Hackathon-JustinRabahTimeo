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

public struct IssuerRemoved has copy, drop, store {
    addr: address
}

    // Initialise le registre des émetteurs
    public entry fun init_registry(initial_admin: address, ctx: &mut TxContext) {
        let registry = Issuers {
            id: object::new(ctx),
            admins: vector::singleton(initial_admin),
            addrs: vector::empty<address>(),
        };
        let caller = sender(ctx);
        transfer::transfer(registry, caller);
    }

    // Ajoute une adresse d’émetteur autorisé (vérifie l'admin via l'appelant)
    public entry fun add_issuer(mut reg: Issuers, new_issuer: address, ctx: &mut TxContext) {
        let caller = sender(ctx);
        assert!(contains(&reg.admins, &caller), E_NOT_ADMIN);
        assert!(!contains(&reg.addrs, &new_issuer), E_ISSUER_EXISTS);
        vector::push_back(&mut reg.addrs, new_issuer);
        event::emit(IssuerAdded { addr: new_issuer });
        transfer::transfer(reg, caller);
    }

    // Supprime un émetteur (vérifie l'admin via l'appelant)
    public entry fun remove_issuer(mut reg: Issuers, issuer: address, ctx: &mut TxContext) {
        let caller = sender(ctx);
        assert!(contains(&reg.admins, &caller), E_NOT_ADMIN);
        assert!(contains(&reg.addrs, &issuer), E_ISSUER_UNKNOWN);
        remove(&mut reg.addrs, &issuer);
        event::emit(IssuerRemoved { addr: issuer });
        transfer::transfer(reg, caller);
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