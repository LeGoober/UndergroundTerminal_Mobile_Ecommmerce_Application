package com.undergroundterminal.api.services;

import com.undergroundterminal.api.entity.Product;
import com.undergroundterminal.api.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService implements IProductService{
    @Autowired
    private ProductRepository productRepository;

    @Override
    public Product create(Product product) {
        return productRepository.save(product);
    }

    @Override
    public Product read(Long aLong) {
        return productRepository.findById(aLong).orElse(null);
    }

    @Override
    public Product update(Product product) {
        return productRepository.save(product);
    }

    @Override
    public void delete(Long aLong) {
        productRepository.deleteById(aLong);
    }

    public List<Product> findAll() {
        return productRepository.findAll();
    }

    public List<Product> findBySupplierId(Long supplierId){
        return productRepository.findBySupplierId(supplierId);
    }

    public List<Product> findByNameContainingIgnoreCase(String name){
        return productRepository.findByNameContainingIgnoreCase(name);
    }

    public List<Product> findByPriceBetween(Double minPrice, Double maxPrice){
        return productRepository.findByPriceBetween(minPrice, maxPrice);
    }

}
