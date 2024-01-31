module bank::bank {
    use sui::object::{Self, UID};
    use sui::dynamic_field; 
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance}; 
    use sui::transfer;
    use sui::tx_context::{Self, TxContext}; 
    use sui::sui::SUI; 

    struct Bank has key {
        id: UID
    }

    struct OwnerCap has key, store {
        id: UID
    }

    struct UserBalance has copy, drop, store { user: address }
    struct AdminBalance has copy, drop, store {}

    const FEE: u128 = 5; 

    fun init(ctx: &mut TxContext) {
        let bank = Bank { id: object::new(ctx) };
        dynamic_field::add(
            &mut bank.id,
            AdminBalance{},
            balance::zero<SUI>(),
        );

        transfer::share_object(bank);

        transfer::transfer(OwnerCap{id:object::new(ctx)}, tx_context::sender(ctx))
    }

    public fun deposit(self: &mut Bank, token: Coin<SUI>, ctx: &mut TxContext) {
        let value = coin::value(&token); 

        let deposit_value = value - (((value as u128) * FEE / 100) as u64); 
        let admin_fee = value - deposit_value; 
        let sender = tx_context::sender(ctx);

        if (dynamic_field::exists_(&self.id, UserBalance { user: sender })) {
            balance::join(dynamic_field::borrow_mut<UserBalance, Balance<SUI>>(&mut self.id, UserBalance { user: sender }), 
            coin::into_balance(token)); 
        } else {
            dynamic_field::add(&mut self.id, UserBalance { user: sender }, coin::into_balance(token)); 
        };
    }

    public fun withdraw(self: &mut Bank, ctx: &mut TxContext, amount: u64): Coin<SUI> {
        let sender = tx_context::sender(ctx);

        if (dynamic_field::exists_(&self.id, UserBalance { user: sender })) {
            coin::from_balance(balance::split(dynamic_field::borrow_mut<UserBalance, Balance<SUI>>(&mut self.id, UserBalance { user:sender }), amount), ctx)
        } else {
            coin::zero(ctx) 
        }
    }

    public fun claim(_: &OwnerCap, self: &mut Bank, ctx: &mut TxContext): Coin<SUI> {
        coin::from_balance(dynamic_field::remove(&mut self.id, AdminBalance {}), ctx)
    }
}