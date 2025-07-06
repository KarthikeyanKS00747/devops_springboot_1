INSERT INTO roles(name) VALUES('ROLE_USER');
INSERT INTO roles(name) VALUES('ROLE_MODERATOR');
INSERT INTO roles(name) VALUES('ROLE_ADMIN');

-- Sample Products
INSERT INTO products (name, description, price, stock_quantity, category, brand, image_url, is_active, created_at, updated_at) VALUES
('iPhone 15 Pro', 'Latest Apple smartphone with advanced features', 999.99, 50, 'Electronics', 'Apple', 'https://example.com/iphone15.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Samsung Galaxy S24', 'Premium Android smartphone', 849.99, 75, 'Electronics', 'Samsung', 'https://example.com/galaxy-s24.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('MacBook Pro M3', 'Professional laptop with M3 chip', 1999.99, 25, 'Electronics', 'Apple', 'https://example.com/macbook-pro.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Dell XPS 13', 'Ultrabook for professionals', 1299.99, 30, 'Electronics', 'Dell', 'https://example.com/dell-xps13.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Nike Air Max 270', 'Comfortable running shoes', 129.99, 100, 'Footwear', 'Nike', 'https://example.com/nike-air-max.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Adidas Ultraboost 22', 'Performance running shoes', 179.99, 80, 'Footwear', 'Adidas', 'https://example.com/adidas-ultraboost.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Levi''s 501 Jeans', 'Classic straight fit jeans', 59.99, 150, 'Clothing', 'Levi''s', 'https://example.com/levis-501.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Sony WH-1000XM5', 'Noise-cancelling wireless headphones', 399.99, 60, 'Electronics', 'Sony', 'https://example.com/sony-headphones.jpg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
