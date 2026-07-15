package com.undergroundterminal.api.repository;

import com.undergroundterminal.api.entity.Consignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Queries that feed JSON responses fetch-join order/buyer because
 * open-in-view is disabled — the consignment JSON exposes orderId
 * and buyerName.
 */
@Repository
public interface ConsignmentRepository extends JpaRepository<Consignment, Long> {

    @Query("select c from Consignment c join fetch c.order o join fetch o.buyer " +
           "where o.buyer.id = :buyerId order by c.createdAt desc")
    List<Consignment> findByBuyerIdWithOrder(Long buyerId);

    /** Consignments whose order contains at least one product from the given supplier. */
    @Query("select distinct c from Consignment c join fetch c.order o join fetch o.buyer " +
           "where c.id in (select c2.id from Consignment c2 join c2.order.items i " +
           "where i.product.supplier.id = :supplierId) order by c.createdAt desc")
    List<Consignment> findBySupplierIdWithOrder(Long supplierId);

    @Query("select c from Consignment c join fetch c.order o join fetch o.buyer where c.id = :id")
    Optional<Consignment> findByIdWithOrder(Long id);

    long countByStatusNot(Consignment.ConsignmentStatus status);
}
