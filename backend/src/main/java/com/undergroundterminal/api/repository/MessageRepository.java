package com.undergroundterminal.api.repository;

import com.undergroundterminal.api.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {

    @Query("select m from Message m join fetch m.sender join fetch m.recipient " +
           "where (m.sender.id = :userA and m.recipient.id = :userB) " +
           "or (m.sender.id = :userB and m.recipient.id = :userA) order by m.sentAt asc")
    List<Message> findConversation(Long userA, Long userB);

    @Query("select m from Message m join fetch m.sender join fetch m.recipient " +
           "where m.sender.id = :userId or m.recipient.id = :userId order by m.sentAt desc")
    List<Message> findAllForUser(Long userId);
}
