package com.undergroundterminal.api.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString(exclude = {"buyer", "items"})
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyer_id", nullable = false)
    @JsonIgnore
    private User buyer;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<OrderItem> items = new ArrayList<>();

    @Column(nullable = false)
    private Double total;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private OrderStatus status;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    /**
     * Expose buyer ID/name directly in JSON for Flutter compatibility,
     * mirroring the supplierId pattern on Product.
     */
    @JsonProperty("buyerId")
    public Long getBuyerId() {
        return buyer != null ? buyer.getId() : null;
    }

    @JsonProperty("buyerName")
    public String getBuyerName() {
        return buyer != null ? buyer.getName() : null;
    }

    public enum OrderStatus {
        PLACED, CONFIRMED, FULFILLED, CANCELLED
    }
}
