
CREATE DATABASE IF NOT EXISTS northwind_dwh;
USE northwind_dwh;

-- =========================
-- DIMENSION TABLES
-- =========================

-- CUSTOMER DIM
CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(10),
    company_name VARCHAR(50),
    contact_name VARCHAR(50),
    email_address VARCHAR(100),
    job_title VARCHAR(50),
    business_phone VARCHAR(20),
    home_phone VARCHAR(20),
    mobile_phone VARCHAR(20),
    fax_number VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    region VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    web_page VARCHAR(200)
);

-- SUPPLIER DIM
CREATE TABLE dim_supplier(
	supplier_key INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id VARCHAR(10),
    supplier_name VARCHAR(100),
    supplier_contact VARCHAR(100),
    supplier_email VARCHAR(50),
    supplier_phone VARCHAR(20),
    supplier_fax VARCHAR(20),
    supplier_address VARCHAR(200),
    supplier_city VARCHAR(50),
    supplier_region VARCHAR(50)
);
-- EMPLOYEE DIM
CREATE TABLE dim_employee (
    employee_key INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(10),
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    email_address VARCHAR(50),
    job_title VARCHAR(50),
    business_phone VARCHAR(20),
    home_phone VARCHAR(20),
    mobile_phone VARCHAR(20),
    fax_number VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    web_page VARCHAR(200),
    hire_date DATE,
    termination_date DATE
);

-- DIMENSION STATUS
CREATE TABLE dim_status (
    status_key INT AUTO_INCREMENT PRIMARY KEY,
    status_id VARCHAR(10),
    status_name VARCHAR(50)
);

-- DIMENSION PRODUCT
CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(10),
    product_code VARCHAR(50),
    product_name VARCHAR(50),
    description TEXT,
    standard_cost DECIMAL(12,2),
    list_price DECIMAL(12,2),
    reorder_level INT,
    target_level INT,
    quantity_per_unit VARCHAR(50),
    discontinued BOOLEAN,
    minimum_reorder_qty INT,
    category VARCHAR(50),
    attachments VARCHAR(200)
);

-- DIMENSION SHIPPER
CREATE TABLE dim_shipper (
    shipper_key INT AUTO_INCREMENT PRIMARY KEY,
    shipper_id VARCHAR(10),
    company_name VARCHAR(50),
    phone VARCHAR(20)
);

-- DIMENSION DATE
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,        -- YYYYMMDD
    full_date DATE,
    day INT,
    day_name VARCHAR(20),
   --  week INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT,
    is_weekend CHAR(1)
);

-- ======================
-- FACT TABLES
-- ======================

CREATE TABLE fact_sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,

    -- Date Dimensions
    order_date_key INT,
    shipped_date_key INT,
    paid_date_key INT,

    -- Other Dimensions
    product_key INT,
    customer_key INT,
    employee_key INT,
    shipper_key INT,
    status_key INT,

    -- Business keys & Measures
    order_id INT,
    order_line_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(10,2),
    tax_rate DECIMAL(5,2),
    sales_amount DECIMAL(12,2),

    -- Foreign Keys
    CONSTRAINT fk_factsales_orderdate  FOREIGN KEY (order_date_key)  REFERENCES dim_date(date_key),
    CONSTRAINT fk_factsales_shippeddate FOREIGN KEY (shipped_date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_factsales_paiddate   FOREIGN KEY (paid_date_key)   REFERENCES dim_date(date_key),
    CONSTRAINT fk_factsales_product    FOREIGN KEY (product_key)     REFERENCES dim_product(product_key),
    CONSTRAINT fk_factsales_customer   FOREIGN KEY (customer_key)    REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_factsales_employee   FOREIGN KEY (employee_key)    REFERENCES dim_employee(employee_key),
    CONSTRAINT fk_factsales_shipper    FOREIGN KEY (shipper_key)     REFERENCES dim_shipper(shipper_key),
    CONSTRAINT fk_factsales_status     FOREIGN KEY (status_key)      REFERENCES dim_status(status_key)
);
