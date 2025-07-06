package com.ecommerce.integration;

import com.ecommerce.dto.request.ProductRequest;
import com.ecommerce.entity.Product;
import com.ecommerce.repository.ProductRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
class ProductIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ObjectMapper objectMapper;

    private Product testProduct;
    private ProductRequest testProductRequest;

    @BeforeEach
    void setUp() {
        productRepository.deleteAll();

        testProduct = new Product();
        testProduct.setName("Integration Test Product");
        testProduct.setDescription("Integration Test Description");
        testProduct.setPrice(new BigDecimal("149.99"));
        testProduct.setStockQuantity(20);
        testProduct.setCategory("Electronics");
        testProduct.setIsActive(true);

        testProductRequest = new ProductRequest();
        testProductRequest.setName("New Integration Product");
        testProductRequest.setDescription("New Description");
        testProductRequest.setPrice(new BigDecimal("199.99"));
        testProductRequest.setStockQuantity(15);
        testProductRequest.setCategory("Electronics");
    }

    @Test
    void getAllProducts_ShouldReturnAllActiveProducts() throws Exception {
        // Given
        productRepository.save(testProduct);

        // When & Then
        mockMvc.perform(get("/api/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].name").value("Integration Test Product"))
                .andExpect(jsonPath("$.totalElements").value(1));
    }

    @Test
    void getProductById_ShouldReturnSpecificProduct() throws Exception {
        // Given
        Product savedProduct = productRepository.save(testProduct);

        // When & Then
        mockMvc.perform(get("/api/products/" + savedProduct.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Integration Test Product"))
                .andExpect(jsonPath("$.price").value(149.99));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void createProduct_ShouldPersistProduct() throws Exception {
        // When
        mockMvc.perform(post("/api/products")
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testProductRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.name").value("New Integration Product"));

        // Then
        assertEquals(1, productRepository.count());
        Product savedProduct = productRepository.findAll().get(0);
        assertEquals("New Integration Product", savedProduct.getName());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void updateProduct_ShouldModifyExistingProduct() throws Exception {
        // Given
        Product savedProduct = productRepository.save(testProduct);
        testProductRequest.setName("Updated Product Name");

        // When
        mockMvc.perform(put("/api/products/" + savedProduct.getId())
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testProductRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Updated Product Name"));

        // Then
        Product updatedProduct = productRepository.findById(savedProduct.getId()).orElseThrow();
        assertEquals("Updated Product Name", updatedProduct.getName());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void deleteProduct_ShouldDeactivateProduct() throws Exception {
        // Given
        Product savedProduct = productRepository.save(testProduct);

        // When
        mockMvc.perform(delete("/api/products/" + savedProduct.getId())
                .with(csrf()))
                .andExpect(status().isOk());

        // Then
        Product deletedProduct = productRepository.findById(savedProduct.getId()).orElseThrow();
        assertTrue(!deletedProduct.getIsActive());
    }

    @Test
    void searchProducts_ShouldReturnMatchingProducts() throws Exception {
        // Given
        productRepository.save(testProduct);

        // When & Then
        mockMvc.perform(get("/api/products/search")
                .param("keyword", "Integration"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].name").value("Integration Test Product"));
    }
}
