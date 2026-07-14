package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Consignment;
import com.undergroundterminal.api.entity.Order;
import com.undergroundterminal.api.entity.User;

import java.util.List;

public interface IConsignmentService extends IService<Consignment, Long> {

    Consignment createForOrder(Order order);

    /** Buyers/designers see consignments on their orders; suppliers see consignments carrying their products. */
    List<Consignment> listForUser(User user);

    Consignment advanceStatus(Long consignmentId, Consignment.ConsignmentStatus status, String note);
}
