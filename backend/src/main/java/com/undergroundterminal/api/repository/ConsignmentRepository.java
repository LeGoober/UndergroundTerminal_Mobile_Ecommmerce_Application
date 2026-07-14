package com.undergroundterminal.api.repository;

import com.undergroundterminal.api.entity.Consignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConsignmentRepository extends JpaRepository<Consignment, Long> {

    List<Consignment> findByOrder_Buyer_IdOrderByCreatedAtDesc(Long buyerId);

    /** Consignments whose order contains at least one product from the given supplier. */
    @Query("select distinct c from Consignment c join c.order.items i where i.product.supplier.id = :supplierId order by c.createdAt desc")
    List<Consignment> findBySupplierId(Long supplierId);

    long countByStatusNot(Consignment.ConsignmentStatus status);
}
