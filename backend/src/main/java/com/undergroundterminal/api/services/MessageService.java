package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Message;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.MessageRepository;
import com.undergroundterminal.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class MessageService implements IMessageService {

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    public Message create(Message message) {
        return messageRepository.save(message);
    }

    @Override
    public Message read(Long id) {
        return messageRepository.findById(id).orElse(null);
    }

    @Override
    public Message update(Message message) {
        return messageRepository.save(message);
    }

    @Override
    public void delete(Long id) {
        messageRepository.deleteById(id);
    }

    @Override
    public Message send(User sender, Long recipientId, String content) {
        if (content == null || content.isBlank()) {
            throw new IllegalArgumentException("Message content cannot be empty");
        }
        User recipient = userRepository.findById(recipientId)
                .orElseThrow(() -> new IllegalArgumentException("Recipient not found: " + recipientId));

        return messageRepository.save(Message.builder()
                .sender(sender)
                .recipient(recipient)
                .content(content.trim())
                .sentAt(LocalDateTime.now())
                .build());
    }

    @Override
    public List<Message> conversation(Long userId, Long otherUserId) {
        return messageRepository.findConversation(userId, otherUserId);
    }

    @Override
    public List<Message> conversationSummaries(Long userId) {
        List<Message> all = messageRepository.findAllForUser(userId);
        Set<Long> seenPartners = new HashSet<>();
        List<Message> summaries = new ArrayList<>();
        for (Message m : all) {
            Long partnerId = m.getSenderId().equals(userId) ? m.getRecipientId() : m.getSenderId();
            if (seenPartners.add(partnerId)) {
                summaries.add(m);
            }
        }
        return summaries;
    }
}
