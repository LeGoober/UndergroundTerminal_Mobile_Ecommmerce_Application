package com.undergroundterminal.api.controller;

import com.undergroundterminal.api.entity.Message;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.UserRepository;
import com.undergroundterminal.api.services.MessageService;
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
@RequestMapping("/api/messages")
@Tag(name = "Messages", description = "Client/business messaging APIs (REST; live delivery via /ws/chat)")
@CrossOrigin(origins = "*")
public class MessageController {

    @Autowired
    private MessageService messageService;

    @Autowired
    private UserRepository userRepository;

    public record SendMessageRequest(Long recipientId, String content) {}

    @GetMapping("/conversations")
    @Operation(summary = "Get the latest message per conversation partner")
    public ResponseEntity<List<Message>> conversations(Authentication authentication) {
        User user = currentUser(authentication);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.ok(messageService.conversationSummaries(user.getId()));
    }

    @GetMapping("/conversation/{otherUserId}")
    @Operation(summary = "Get the full conversation with another user, oldest first")
    public ResponseEntity<List<Message>> conversation(@PathVariable Long otherUserId,
                                                      Authentication authentication) {
        User user = currentUser(authentication);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.ok(messageService.conversation(user.getId(), otherUserId));
    }

    @PostMapping
    @Operation(summary = "Send a message (REST fallback; WebSocket clients use /ws/chat)")
    public ResponseEntity<?> send(@RequestBody SendMessageRequest request, Authentication authentication) {
        User sender = currentUser(authentication);
        if (sender == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unknown user"));
        }
        try {
            Message message = messageService.send(sender, request.recipientId(), request.content());
            return ResponseEntity.status(HttpStatus.CREATED).body(message);
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
