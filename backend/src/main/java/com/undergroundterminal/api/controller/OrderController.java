package com.undergroundterminal.api.controller;

import com.undergroundterminal.api.entity.Order;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.UserRepository;
import com.undergroundterminal.api.services.IOrderService;
import com.undergroundterminal.api.services.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
@Tag(name = "Orders", description = "Order placement and history APIs")
@CrossOrigin(origins = "*")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserRepository userRepository;

    public record PlaceOrderRequest(List<IOrderService.OrderLine> items) {}

    @PostMapping
    @Operation(summary = "Place an order from a list of product lines")
    public ResponseEntity<?> placeOrder(@RequestBody PlaceOrderRequest request, Authentication authentication) {
        User buyer = currentUser(authentication);
        if (buyer == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unknown user"));
        }
        try {
            Order order = orderService.placeOrder(buyer, request.items());
            return ResponseEntity.status(HttpStatus.CREATED).body(order);
        } catch (IllegalArgumentException | IllegalStateException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/mine")
    @Operation(summary = "Get the current user's orders (as buyer, or as supplier of ordered products)")
    public ResponseEntity<List<Order>> myOrders(Authentication authentication) {
        User user = currentUser(authentication);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        List<Order> orders = user.getRole() == User.UserRole.SUPPLIER
                ? orderService.findBySupplierId(user.getId())
                : orderService.findByBuyerId(user.getId());
        return ResponseEntity.ok(orders);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get an order by ID")
    public ResponseEntity<Order> getOrder(@PathVariable Long id) {
        Order order = orderService.read(id);
        if (order != null) {
            return ResponseEntity.ok(order);
        }
        return ResponseEntity.notFound().build();
    }

    private User currentUser(Authentication authentication) {
        if (authentication == null) {
            return null;
        }
        return userRepository.findByEmail(authentication.getName()).orElse(null);
    }
}
