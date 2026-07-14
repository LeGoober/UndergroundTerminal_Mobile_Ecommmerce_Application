package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Message;
import com.undergroundterminal.api.entity.User;

import java.util.List;

public interface IMessageService extends IService<Message, Long> {

    Message send(User sender, Long recipientId, String content);

    List<Message> conversation(Long userId, Long otherUserId);

    /** Latest message per conversation partner, newest first. */
    List<Message> conversationSummaries(Long userId);
}
