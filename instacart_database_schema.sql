-- =========================================
-- 1. Create Database
-- =========================================
CREATE DATABASE instacart;

-- NOTE: You cannot use IF NOT EXISTS with CREATE DATABASE in older PostgreSQL versions.
-- Run this manually if needed, then connect:

-- \c instacart


-- =========================================
-- 2. Create Tables
-- =========================================

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    eval_set TEXT,
    order_number INT,
    order_dow INT,
    order_hour_of_day INT,
    days_since_prior_order FLOAT
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    aisle_id INT,
    department_id INT
);

CREATE TABLE IF NOT EXISTS aisles (
    aisle_id INT PRIMARY KEY,
    aisle TEXT
);

CREATE TABLE IF NOT EXISTS departments (
    department_id INT PRIMARY KEY,
    department TEXT
);

CREATE TABLE IF NOT EXISTS order_products_prior (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT
);

CREATE TABLE IF NOT EXISTS order_products_train (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT
);


-- =========================================
-- 3. Import Data (UPDATE FILE PATHS)
-- =========================================

-- IMPORTANT: Replace '/path/...' with your actual file paths

COPY orders
FROM '/path/orders.csv'
DELIMITER ','
CSV HEADER;

COPY products
FROM '/path/products.csv'
DELIMITER ','
CSV HEADER;

COPY aisles
FROM '/path/aisles.csv'
DELIMITER ','
CSV HEADER;

COPY departments
FROM '/path/departments.csv'
DELIMITER ','
CSV HEADER;

COPY order_products_prior
FROM '/path/order_products__prior.csv'
DELIMITER ','
CSV HEADER;

COPY order_products_train
FROM '/path/order_products__train.csv'
DELIMITER ','
CSV HEADER;


-- =========================================
-- 4. Add Constraints (Optional but Recommended)
-- =========================================

DO $$
BEGIN
    -- products → aisles
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_products_aisle'
    ) THEN
        ALTER TABLE products
        ADD CONSTRAINT fk_products_aisle
        FOREIGN KEY (aisle_id) REFERENCES aisles(aisle_id);
    END IF;

    -- products → departments
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_products_department'
    ) THEN
        ALTER TABLE products
        ADD CONSTRAINT fk_products_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id);
    END IF;

    -- order_products_prior → orders
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_prior_orders'
    ) THEN
        ALTER TABLE order_products_prior
        ADD CONSTRAINT fk_prior_orders
        FOREIGN KEY (order_id) REFERENCES orders(order_id);
    END IF;

    -- order_products_prior → products
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_prior_products'
    ) THEN
        ALTER TABLE order_products_prior
        ADD CONSTRAINT fk_prior_products
        FOREIGN KEY (product_id) REFERENCES products(product_id);
    END IF;
END $$;


-- =========================================
-- 5. Create Unified Fact Table
-- =========================================

CREATE TABLE IF NOT EXISTS order_products AS
SELECT * FROM order_products_prior
UNION ALL
SELECT * FROM order_products_train;


-- =========================================
-- DONE
-- =========================================