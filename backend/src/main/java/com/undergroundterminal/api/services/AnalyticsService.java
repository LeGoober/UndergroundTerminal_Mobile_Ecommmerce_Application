package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Consignment;
import com.undergroundterminal.api.entity.Order;
import com.undergroundterminal.api.entity.Product;
import com.undergroundterminal.api.repository.ConsignmentRepository;
import com.undergroundterminal.api.repository.OrderRepository;
import com.undergroundterminal.api.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Computes the platform analytics summary in memory. Dataset sizes at MVP
 * scale (tens of products, hundreds of orders) make dedicated aggregate
 * queries unnecessary; revisit if order volume grows.
 */
@Service
public class AnalyticsService {

    private static final int LOW_STOCK_THRESHOLD = 5;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ConsignmentRepository consignmentRepository;

    public Map<String, Object> summary() {
        List<Product> products = productRepository.findAll();

        int totalStockUnits = products.stream().mapToInt(Product::getStockLevel).sum();
        long lowStockCount = products.stream()
                .filter(p -> p.getStockLevel() < LOW_STOCK_THRESHOLD)
                .count();

        // Orders per day for the trailing 7 days (inclusive of today)
        LocalDate today = LocalDate.now();
        LocalDateTime windowStart = today.minusDays(6).atStartOfDay();
        List<Order> recentOrders = orderRepository.findByCreatedAtAfter(windowStart);

        List<Map<String, Object>> ordersByDay = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            long count = recentOrders.stream()
                    .filter(o -> o.getCreatedAt().toLocalDate().equals(day))
                    .count();
            Map<String, Object> entry = new LinkedHashMap<>();
            entry.put("date", day.toString());
            entry.put("orders", count);
            ordersByDay.add(entry);
        }

        List<Map<String, Object>> topStock = products.stream()
                .sorted(Comparator.comparingInt(Product::getStockLevel).reversed())
                .limit(6)
                .map(p -> {
                    Map<String, Object> entry = new LinkedHashMap<>();
                    entry.put("name", p.getName());
                    entry.put("stockLevel", p.getStockLevel());
                    return entry;
                })
                .toList();

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("totalProducts", products.size());
        summary.put("totalStockUnits", totalStockUnits);
        summary.put("lowStockCount", lowStockCount);
        summary.put("totalOrders", orderRepository.count());
        summary.put("totalRevenue", orderRepository.sumTotals());
        summary.put("activeConsignments",
                consignmentRepository.countByStatusNot(Consignment.ConsignmentStatus.DELIVERED));
        summary.put("ordersByDay", ordersByDay);
        summary.put("topStock", topStock);
        return summary;
    }
}
