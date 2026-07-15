package com.undergroundterminal.api.config;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.undergroundterminal.api.entity.Message;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.UserRepository;
import com.undergroundterminal.api.services.MessageService;
import com.undergroundterminal.api.util.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Raw-WebSocket chat endpoint (no STOMP) so the Flutter client can use a
 * plain WebSocket connection.
 *
 * Connect with:   ws://host/ws/chat?token=&lt;JWT&gt;
 * Send frames:    {"recipientId": 7, "content": "..."}
 * Receive frames: the persisted Message entity as JSON
 */
@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private static final Logger logger = LoggerFactory.getLogger(ChatWebSocketHandler.class);

    /** Live sessions keyed by user ID. One session per user; latest wins. */
    private final Map<Long, WebSocketSession> sessions = new ConcurrentHashMap<>();

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MessageService messageService;

    @Autowired
    private ObjectMapper objectMapper;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        User user = authenticate(session);
        if (user == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Invalid or missing token"));
            return;
        }
        session.getAttributes().put("userId", user.getId());
        sessions.put(user.getId(), session);
        logger.info("WebSocket connected: user {} ({} online)", user.getId(), sessions.size());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
        Long userId = (Long) session.getAttributes().get("userId");
        if (userId == null) {
            session.close(CloseStatus.POLICY_VIOLATION);
            return;
        }

        try {
            JsonNode payload = objectMapper.readTree(textMessage.getPayload());
            Long recipientId = payload.path("recipientId").asLong(0);
            String content = payload.path("content").asText("");

            User sender = userRepository.findById(userId).orElse(null);
            if (sender == null) {
                session.close(CloseStatus.SERVER_ERROR);
                return;
            }

            Message saved = messageService.send(sender, recipientId, content);
            String json = objectMapper.writeValueAsString(saved);

            // Echo to sender (delivery confirmation) and push to recipient if online
            sendTo(session, json);
            WebSocketSession recipientSession = sessions.get(recipientId);
            if (recipientSession != null && recipientSession.isOpen()) {
                sendTo(recipientSession, json);
            }
        } catch (IllegalArgumentException e) {
            sendTo(session, objectMapper.writeValueAsString(Map.of("error", e.getMessage())));
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        Long userId = (Long) session.getAttributes().get("userId");
        if (userId != null) {
            sessions.remove(userId, session);
        }
    }

    private User authenticate(WebSocketSession session) {
        try {
            String query = session.getUri() != null ? session.getUri().getQuery() : null;
            if (query == null) {
                return null;
            }
            String token = null;
            for (String param : query.split("&")) {
                if (param.startsWith("token=")) {
                    token = param.substring("token=".length());
                    break;
                }
            }
            if (token == null || token.isBlank()) {
                return null;
            }
            String email = jwtUtil.extractEmail(token);
            if (email == null || !jwtUtil.isTokenValid(token, email)) {
                return null;
            }
            return userRepository.findByEmail(email).orElse(null);
        } catch (Exception e) {
            logger.warn("WebSocket authentication failed: {}", e.getMessage());
            return null;
        }
    }

    private synchronized void sendTo(WebSocketSession session, String json) {
        try {
            if (session.isOpen()) {
                session.sendMessage(new TextMessage(json));
            }
        } catch (Exception e) {
            logger.warn("Failed to push WebSocket frame: {}", e.getMessage());
        }
    }
}
