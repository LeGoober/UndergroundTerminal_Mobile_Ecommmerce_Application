package com.undergroundterminal.api.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "products")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString(exclude = "supplier")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private Double price;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "stock_level")
    private int stockLevel;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "supplier_id", nullable = false)
    @JsonIgnore
    private User supplier;

    /**
     * Expose supplier ID directly in JSON for Flutter compatibility.
     * The Flutter Product model expects supplierId as an integer,
     * not the full User object.
     */
    @JsonProperty("supplierId")
    public Long getSupplierId() {
        return supplier != null ? supplier.getId() : null;
    }

    /**
     * Allow deserialization of supplierId from JSON requests (POST/PUT).
     * Creates a User reference with the given ID for JPA relationship mapping.
     */
    @JsonProperty("supplierId")
    public void setSupplierId(Long supplierId) {
        if (supplierId != null) {
            this.supplier = User.builder().id(supplierId).build();
        }
    }
}
