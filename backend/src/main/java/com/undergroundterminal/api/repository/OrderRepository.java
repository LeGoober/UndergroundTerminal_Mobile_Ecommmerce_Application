package com.undergroundterminal.api.repository;

import com.undergroundterminal.api.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Queries that feed JSON responses fetch-join buyer/items/product because
 * open-in-view is disabled — lazy proxies cannot be initialized during
 * serialization.
 */
@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    @Query("select distinct o from Order o join fetch o.buyer left join fetch o.items i " +
           "left join fetch i.product where o.buyer.id = :buyerId order by o.createdAt desc")
    List<Order> findByBuyerIdWithItems(Long buyerId);

    /** Orders containing at least one product from the given supplier. */
    @Query("select distinct o from Order o join fetch o.buyer left join fetch o.items i " +
           "left join fetch i.product where o.id in " +
           "(select o2.id from Order o2 join o2.items i2 where i2.product.supplier.id = :supplierId) " +
           "order by o.createdAt desc")
    List<Order> findBySupplierIdWithItems(Long supplierId);

    @Query("select o from Order o join fetch o.buyer left join fetch o.items i " +
           "left join fetch i.product where o.id = :id")
    Optional<Order> findByIdWithItems(Long id);

    List<Order> findByCreatedAtAfter(LocalDateTime since);

    @Query("select coalesce(sum(o.total), 0) from Order o where o.status <> 'CANCELLED'")
    Double sumTotals();
}
