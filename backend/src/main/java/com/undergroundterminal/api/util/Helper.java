package com.undergroundterminal.api.util;

import com.undergroundterminal.api.entity.User;
import org.apache.commons.validator.routines.EmailValidator;

public class Helper {

    public static boolean isNullOrEmpty(String str) {
        return str == null || str.isEmpty();
    }

    public static boolean isValidUserRole(User.UserRole userRole) {
        return userRole != null;
    }

    public static boolean isValidEmail(String email) {
        return email != null && EmailValidator.getInstance().isValid(email);
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 8;
    }

    public static boolean isSupplier(User user) {
        return user != null && user.getRole() == User.UserRole.SUPPLIER;
    }

    public static boolean isValidProductPrice(Double price) {
        return price != null && price >= 0;
    }

    public static boolean isValidProductImageUrl(String imageUrl) {
        return imageUrl != null && imageUrl.length() >= 3;
    }

    public static boolean isValidProductDescription(String description) {
        return description != null && description.length() >= 10;
    }
}
