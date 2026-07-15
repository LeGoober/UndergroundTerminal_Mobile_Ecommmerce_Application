package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Order;
import com.undergroundterminal.api.entity.OrderItem;
import com.undergroundterminal.api.entity.Product;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.OrderRepository;
import com.undergroundterminal.api.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class OrderService implements IOrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ConsignmentService consignmentService;

    @Override
    public Order create(Order order) {
        return orderRepository.save(order);
    }

    @Override
    public Order read(Long id) {
        return orderRepository.findByIdWithItems(id).orElse(null);
    }

    @Override
    public Order update(Order order) {
        return orderRepository.save(order);
    }

    @Override
    public void delete(Long id) {
        orderRepository.deleteById(id);
    }

    /**
     * Places an order atomically: validates and decrements stock for every
     * line, persists the order, and opens a consignment for tracking.
     */
    @Override
    @Transactional
    public Order placeOrder(User buyer, List<OrderLine> lines) {
        if (lines == null || lines.isEmpty()) {
            throw new IllegalArgumentException("Order must contain at least one item");
        }

        List<OrderItem> items = new ArrayList<>();
        double total = 0.0;

        Order order = Order.builder()
                .buyer(buyer)
                .status(Order.OrderStatus.PLACED)
                .createdAt(LocalDateTime.now())
                .total(0.0)
                .build();

        for (OrderLine line : lines) {
            Product product = productRepository.findById(line.productId())
                    .orElseThrow(() -> new IllegalArgumentException("Product not found: " + line.productId()));
            if (line.quantity() <= 0) {
                throw new IllegalArgumentException("Quantity must be positive for product " + product.getName());
            }
            if (product.getStockLevel() < line.quantity()) {
                throw new IllegalStateException("Insufficient stock for " + product.getName()
                        + " (requested " + line.quantity() + ", available " + product.getStockLevel() + ")");
            }
            product.setStockLevel(product.getStockLevel() - line.quantity());
            productRepository.save(product);

            items.add(OrderItem.builder()
                    .order(order)
                    .product(product)
                    .quantity(line.quantity())
                    .unitPrice(product.getPrice())
                    .build());
            total += product.getPrice() * line.quantity();
        }

        order.setItems(items);
        order.setTotal(total);
        Order saved = orderRepository.save(order);

        consignmentService.createForOrder(saved);
        return saved;
    }

    @Override
    public List<Order> findByBuyerId(Long buyerId) {
        return orderRepository.findByBuyerIdWithItems(buyerId);
    }

    @Override
    public List<Order> findBySupplierId(Long supplierId) {
        return orderRepository.findBySupplierIdWithItems(supplierId);
    }
}
