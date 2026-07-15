package com.undergroundterminal.api.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.*;

import java.time.LocalDateTime;

/** A single entry in a consignment's status timeline. */
@Embeddable
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
public class ConsignmentEvent {

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Consignment.ConsignmentStatus status;

    private String note;

    @Column(nullable = false)
    private LocalDateTime timestamp;
}
