package com.example.shop;

public class CartService {
    static final int MAX_ITEMS = 50;

    public void add(Cart cart, Item item) {
        if (cart.size() >= MAX_ITEMS) throw new IllegalStateException("cart full");
        cart.add(item);
    }
}
