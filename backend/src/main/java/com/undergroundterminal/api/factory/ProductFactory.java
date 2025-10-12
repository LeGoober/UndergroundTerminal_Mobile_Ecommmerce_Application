package com.undergroundterminal.api.factory;

import com.undergroundterminal.api.entity.Product;
import com.undergroundterminal.api.entity.User;
import com.undergroundterminal.api.util.Helper;

public class ProductFactory {

    public static Product createProduct(String name,
                                        Double price,
                                        String imageUrl,
                                        String description,
                                        int stockLevel,
                                        User supplier) {

        if (Helper.isNullOrEmpty(name) ||
                Helper.isNullOrEmpty(imageUrl) ||
                !Helper.isValidProductPrice(price) ||
                !Helper.isValidProductDescription(description) ||
                !Helper.isValidProductImageUrl(imageUrl) ||
                !Helper.isSupplier(supplier) ||
                stockLevel < 0) {
            return null;
        }

        return Product.builder()
                .name(name)
                .price(price)
                .imageUrl(imageUrl)
                .description(description)
                .stockLevel(stockLevel)
                .supplier(supplier)
                .build();
    }
}
