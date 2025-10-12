package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService implements IUserService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public User create(User user) {
        return userRepository.save(user);
    }

    @Override
    public User read(Long aLong) {
        return userRepository.findById(aLong).orElse(null);
    }

    @Override
    public User update(User user) {
        return userRepository.save(user);
    }

    @Override
    public void delete(Long aLong) {
        userRepository.deleteById(aLong);
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public List<User> findByRole(User.UserRole role) {
        return userRepository.findByRole(role);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }
}
