package com.undergroundterminal.api.controller;

import com.undergroundterminal.api.entity.Consignment;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.UserRepository;
import com.undergroundterminal.api.services.ConsignmentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/consignments")
@Tag(name = "Consignments", description = "Logistics tracking APIs")
@CrossOrigin(origins = "*")
public class ConsignmentController {

    @Autowired
    private ConsignmentService consignmentService;

    @Autowired
    private UserRepository userRepository;

    public record StatusUpdateRequest(Consignment.ConsignmentStatus status, String note) {}

    @GetMapping("/mine")
    @Operation(summary = "Get consignments visible to the current user")
    public ResponseEntity<List<Consignment>> myConsignments(Authentication authentication) {
        User user = currentUser(authentication);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.ok(consignmentService.listForUser(user));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get a consignment by ID")
    public ResponseEntity<Consignment> getConsignment(@PathVariable Long id) {
        Consignment consignment = consignmentService.read(id);
        if (consignment != null) {
            return ResponseEntity.ok(consignment);
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping("/{id}/status")
    @Operation(summary = "Advance a consignment's status (suppliers only)")
    public ResponseEntity<?> advanceStatus(@PathVariable Long id,
                                           @RequestBody StatusUpdateRequest request,
                                           Authentication authentication) {
        User user = currentUser(authentication);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unknown user"));
        }
        if (user.getRole() != User.UserRole.SUPPLIER) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Only suppliers can update consignment status"));
        }
        try {
            return ResponseEntity.ok(consignmentService.advanceStatus(id, request.status(), request.note()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    private User currentUser(Authentication authentication) {
        if (authentication == null) {
            return null;
        }
        return userRepository.findByEmail(authentication.getName()).orElse(null);
    }
}
