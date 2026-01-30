DROP DATABASE IF EXISTS vending_machines_system;
CREATE DATABASE vending_machines_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vending_machines_system;

CREATE TABLE regions (
  region_id INT AUTO_INCREMENT PRIMARY KEY,
  region_name VARCHAR(100) NOT NULL,
  region_code VARCHAR(10) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vending_machines (
  machine_id INT AUTO_INCREMENT PRIMARY KEY,
  machine_code VARCHAR(50) NOT NULL UNIQUE,
  address VARCHAR(255) NOT NULL,
  gps_latitude DECIMAL(10, 8) NOT NULL,
  gps_longitude DECIMAL(11, 8) NOT NULL,
  region_id INT,
  installation_date DATE,
  last_maintenance_date DATE,
  machine_status ENUM('active', 'maintenance', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE SET NULL
);

CREATE TABLE product_categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE brands (
  brand_id INT AUTO_INCREMENT PRIMARY KEY,
  brand_name VARCHAR(100) NOT NULL UNIQUE,
  manufacturer VARCHAR(150),
  country VARCHAR(50),
  contact_info VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(150) NOT NULL,
  brand_id INT NOT NULL,
  category_id INT NOT NULL,
  barcode VARCHAR(50) UNIQUE,
  weight_grams DECIMAL(8, 2),
  price DECIMAL(10, 2) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE RESTRICT,
  FOREIGN KEY (category_id) REFERENCES product_categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE machine_menu (
  menu_id INT AUTO_INCREMENT PRIMARY KEY,
  machine_id INT NOT NULL,
  product_id INT NOT NULL,
  slot_number VARCHAR(10) NOT NULL,
  max_capacity INT NOT NULL DEFAULT 10,
  current_quantity INT NOT NULL DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (machine_id) REFERENCES vending_machines(machine_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  UNIQUE KEY unique_machine_slot (machine_id, slot_number)
);

INSERT INTO regions (region_name, region_code, description) VALUES
('Центральний район', 'CTR', 'Центр міста'),
('Північний район', 'NTH', 'Житлові масиви');

INSERT INTO vending_machines (machine_code, address, gps_latitude, gps_longitude, region_id, installation_date, last_maintenance_date, machine_status)
VALUES
('VM-001', 'вул. Шевченка, 25', 49.842957, 24.031111, 1, '2023-01-15', '2025-11-20', 'active'),
('VM-002', 'пр. Свободи, 41', 49.839683, 24.029717, 1, '2023-02-10', '2025-11-22', 'active'),
('VM-003', 'вул. Личаківська, 103', 49.833881, 24.041350, 2, '2023-03-05', '2025-11-18', 'active');

INSERT INTO product_categories (category_name, description) VALUES
('Напої', 'Вода/газовані'),
('Шоколадні батончики', 'Батончики');

INSERT INTO brands (brand_name, manufacturer, country, contact_info) VALUES
('Coca-Cola', 'The Coca-Cola Company', 'США', 'support@coca-cola.ua'),
('Snickers', 'Mars Inc.', 'США', 'info@snickers.com');

INSERT INTO products (product_name, brand_id, category_id, barcode, weight_grams, price, description) VALUES
('Coca-Cola 0.33л', 1, 1, '5449000000996', 330.0, 20.00, 'Газований напій'),
('Snickers Original', 2, 2, '5000159461122', 50.0, 25.00, 'Батончик');

INSERT INTO machine_menu (machine_id, product_id, slot_number, max_capacity, current_quantity, is_active) VALUES
(1, 1, 'A1', 12, 8, TRUE),
(1, 2, 'B1', 20, 14, TRUE),
(2, 1, 'A1', 12, 6, TRUE);
