package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Consignment;
import com.undergroundterminal.api.entity.ConsignmentEvent;
import com.undergroundterminal.api.entity.Order;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.ConsignmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ConsignmentService implements IConsignmentService {

    @Autowired
    private ConsignmentRepository consignmentRepository;

    @Override
    public Consignment create(Consignment consignment) {
        return consignmentRepository.save(consignment);
    }

    @Override
    public Consignment read(Long id) {
        return consignmentRepository.findByIdWithOrder(id).orElse(null);
    }

    @Override
    public Consignment update(Consignment consignment) {
        return consignmentRepository.save(consignment);
    }

    @Override
    public void delete(Long id) {
        consignmentRepository.deleteById(id);
    }

    @Override
    @Transactional
    public Consignment createForOrder(Order order) {
        String origin = order.getItems().isEmpty() || order.getItems().get(0).getProduct().getSupplier() == null
                ? "Supplier warehouse"
                : order.getItems().get(0).getProduct().getSupplier().getName();

        Consignment consignment = Consignment.builder()
                .order(order)
                .reference(String.format("LOT-%04d", order.getId()))
                .origin(origin)
                .destination(order.getBuyerName())
                .status(Consignment.ConsignmentStatus.PREPARING)
                .eta(LocalDateTime.now().plusDays(5))
                .createdAt(LocalDateTime.now())
                .build();
        consignment.getEvents().add(ConsignmentEvent.builder()
                .status(Consignment.ConsignmentStatus.PREPARING)
                .note("Consignment opened for order #" + order.getId())
                .timestamp(LocalDateTime.now())
                .build());

        return consignmentRepository.save(consignment);
    }

    @Override
    public List<Consignment> listForUser(User user) {
        if (user.getRole() == User.UserRole.SUPPLIER) {
            return consignmentRepository.findBySupplierIdWithOrder(user.getId());
        }
        return consignmentRepository.findByBuyerIdWithOrder(user.getId());
    }

    @Override
    @Transactional
    public Consignment advanceStatus(Long consignmentId, Consignment.ConsignmentStatus status, String note) {
        Consignment consignment = consignmentRepository.findByIdWithOrder(consignmentId)
                .orElseThrow(() -> new IllegalArgumentException("Consignment not found: " + consignmentId));

        consignment.setStatus(status);
        consignment.getEvents().add(ConsignmentEvent.builder()
                .status(status)
                .note(note)
                .timestamp(LocalDateTime.now())
                .build());

        if (status == Consignment.ConsignmentStatus.DELIVERED && consignment.getOrder() != null) {
            consignment.getOrder().setStatus(Order.OrderStatus.FULFILLED);
        }

        return consignmentRepository.save(consignment);
    }
}
