module my_module::account_manager {
    use std::vector;
    use sui::object::{Self, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::event;
    use sui::clock::{Self, Clock};



 

    /// Erreurs personnalisées
    const ENOT_OWNER: u64 = 0;

    /// Un objet représentant un compte utilisateur
    struct UserAccount has key {
        id: ID,
        owner: address,
        balance: u64,
        tokens: vector<u64>,
    }

    /// Un événement pour enregistrer une action
    struct DepositEvent has drop, store {
        to: address,
        amount: u64,
    }

    /// Création d’un nouvel objet `UserAccount`
    public entry fun create_account(ctx: &mut TxContext): UserAccount {
        let sender = tx_context::sender(ctx);
        UserAccount {
            id: object::new(ctx),
            owner: sender,
            balance: 0,
            tokens: vector::empty<u64>(),
        }
    }

    /// Ajouter des fonds à un compte
    public entry fun deposit(account: &mut UserAccount, amount: u64, ctx: &mut TxContext) {
        assert_is_owner(account, ctx);
        account.balance = account.balance + amount;

        // Émettre un événement de dépôt
        let event = DepositEvent {
            to: account.owner,
            amount,
        };
        event::emit(event);
    }

    /// Retirer des fonds du compte
    public entry fun withdraw(account: &mut UserAccount, amount: u64, ctx: &mut TxContext) {
        assert_is_owner(account, ctx);
        assert!(account.balance >= amount, ENOT_OWNER); // On réutilise le code d’erreur par simplicité
        account.balance = account.balance - amount;
    }

    /// Ajouter un "token" arbitraire au compte
    public entry fun add_token(account: &mut UserAccount, token_id: u64, ctx: &mut TxContext) {
        assert_is_owner(account, ctx);
        vector::push_back(&mut account.tokens, token_id);
    }

    /// Transférer un compte à une autre adresse
    public entry fun transfer_account(account: UserAccount, recipient: address) {
        transfer::transfer(account, recipient);
    }

    /// Supprimer un compte (ex: pour nettoyage)
    public entry fun delete_account(account: UserAccount, ctx: &mut TxContext) {
        // Pas besoin de faire quoi que ce soit de spécial, Move gère la destruction
        // Ici, on pourrait aussi transférer à l'adresse `0x0` ou une DAO.
    }

    /// ⚠️ Fonction privée pour sécuriser l’accès à un objet
    fun assert_is_owner(account: &UserAccount, ctx: &TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(account.owner == sender, ENOT_OWNER);
    }
}