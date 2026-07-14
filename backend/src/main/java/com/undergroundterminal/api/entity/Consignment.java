package com.undergroundterminal.api.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "consignments")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString(exclude = "order")
public class Consignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Human-readable manifest reference, e.g. LOT-0042. */
    @Column(nullable = false, unique = true)
    private String reference;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    @JsonIgnore
    private Order order;

    @Column(nullable = false)
    private String origin;

    @Column(nullable = false)
    private String destination;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ConsignmentStatus status;

    private LocalDateTime eta;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "consignment_events", joinColumns = @JoinColumn(name = "consignment_id"))
    @OrderColumn(name = "event_order")
    @Builder.Default
    private List<ConsignmentEvent> events = new ArrayList<>();

    @JsonProperty("orderId")
    public Long getOrderId() {
        return order != null ? order.getId() : null;
    }

    @JsonProperty("buyerName")
    public String getBuyerName() {
        return order != null ? order.getBuyerName() : null;
    }

    public enum ConsignmentStatus {
        PREPARING, IN_TRANSIT, CUSTOMS, DELIVERED, DELAYED
    }
}
