module sui_attendance::registry {
    use std::vector;
    use sui::object::UID;
    use sui::object;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer;
    use sui::event;

    const E_ISSUER_EXISTS: u64 = 1;
    const E_ISSUER_UNKNOWN: u64 = 2;

    // Liste des émetteurs autorisés
    public struct Issuers has key, store {
        id: UID,
        addrs: vector<address>,
    }

    public struct MintCap has key {
        id: UID,
    }

    // Événements
    public struct IssuerAdded has copy, drop, store {
        addr: address
    }

    public struct IssuerRemoved has copy, drop, store {
        addr: address
    }

    // Initialise le registre des émetteurs
    fun init(ctx: &mut TxContext) {
        let registry = Issuers {
            id: object::new(ctx),
            addrs: vector::empty<address>(),
        };
        let caller = tx_context::sender(ctx);
        transfer::transfer(registry, caller);
    }

    // Ajoute une adresse d’émetteur autorisé (vérifie l'admin via l'appelant)
    public entry fun add_issuer(reg: &mut Issuers, new_issuer: address, ctx: &mut TxContext) {
        let mint_cap = MintCap { id: object::new(ctx)};
        assert!(!contains(&reg.addrs, &new_issuer), E_ISSUER_EXISTS);
        vector::push_back(&mut reg.addrs, new_issuer);
        event::emit(IssuerAdded { addr: new_issuer });
        transfer::transfer(mint_cap, new_issuer);
    }

    // Supprime un émetteur (vérifie l'admin via l'appelant)
    public entry fun remove_issuer(reg: &mut Issuers, issuer: address, ctx: &mut TxContext) {
        assert!(contains(&reg.addrs, &issuer), E_ISSUER_UNKNOWN);
        remove(&mut reg.addrs, &issuer);
        event::emit(IssuerRemoved { addr: issuer });
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