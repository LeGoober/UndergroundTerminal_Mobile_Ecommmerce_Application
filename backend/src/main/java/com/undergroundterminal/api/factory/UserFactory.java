package com.undergroundterminal.api.factory;

import com.undergroundterminal.api.entity.Product;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.util.Helper;

import java.util.List;

public class UserFactory {

    public static User createUser(String name,
                                  String email,
                                  String password,
                                  User.UserRole userRole,
                                  String imageUrl,
                                  String bio,
                                  List<Product> products) {

        if (Helper.isNullOrEmpty(name) ||
                Helper.isNullOrEmpty(email) ||
                !Helper.isValidEmail(email) ||
                !Helper.isValidPassword(password) ||
                !Helper.isValidUserRole(userRole)) {
            return null;
        }

        return User.builder()
                .name(name)
                .email(email)
                .password(password)
                .role(userRole)
                .bio(bio)
                .products(products)
                .imageUrl(imageUrl)
                .build();
    }
}
