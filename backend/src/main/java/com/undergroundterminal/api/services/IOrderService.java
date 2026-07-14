package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Order;
import com.undergroundterminal.api.entity.User;

import java.util.List;

public interface IOrderService extends IService<Order, Long> {

    /** A single requested line in a new order. */
    record OrderLine(Long productId, int quantity) {}

    Order placeOrder(User buyer, List<OrderLine> lines);

    List<Order> findByBuyerId(Long buyerId);

    List<Order> findBySupplierId(Long supplierId);
}
