package com.undergroundterminal.api.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "order_items")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString(exclude = {"order", "product"})
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    @JsonIgnore
    private Order order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @JsonIgnore
    private Product product;

    @Column(nullable = false)
    private int quantity;

    /** Price per unit at the time the order was placed. */
    @Column(name = "unit_price", nullable = false)
    private Double unitPrice;

    @JsonProperty("productId")
    public Long getProductId() {
        return product != null ? product.getId() : null;
    }

    @JsonProperty("productName")
    public String getProductName() {
        return product != null ? product.getName() : null;
    }

    @JsonProperty("productImageUrl")
    public String getProductImageUrl() {
        return product != null ? product.getImageUrl() : null;
    }
}
