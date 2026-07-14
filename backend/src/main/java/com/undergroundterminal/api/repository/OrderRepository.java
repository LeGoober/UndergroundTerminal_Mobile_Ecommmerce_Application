package com.undergroundterminal.api.repository;

import com.undergroundterminal.api.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByBuyer_IdOrderByCreatedAtDesc(Long buyerId);

    /** Orders containing at least one product from the given supplier. */
    @Query("select distinct o from Order o join o.items i where i.product.supplier.id = :supplierId order by o.createdAt desc")
    List<Order> findBySupplierId(Long supplierId);

    List<Order> findByCreatedAtAfter(LocalDateTime since);

    @Query("select coalesce(sum(o.total), 0) from Order o where o.status <> 'CANCELLED'")
    Double sumTotals();
}
