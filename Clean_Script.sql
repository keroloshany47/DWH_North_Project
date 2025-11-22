CREATE SCHEMA IF NOT EXISTS Clean_Northwind;
USE Clean_Northwind;

-- 1) Create clean customers 
CREATE TABLE IF NOT EXISTS Clean_Northwind.customers (
    customer_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    company_short_name VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    full_name VARCHAR(120),
    email VARCHAR(100) DEFAULT 'unknown@northwind.com',
    job_title VARCHAR(100),
    phone_business VARCHAR(25),
    phone_home VARCHAR(25),
    phone_mobile VARCHAR(25),
    phone_fax VARCHAR(25),
    street_address VARCHAR(200),
    city VARCHAR(50),
    state_code VARCHAR(5),
    state_name VARCHAR(50),
    postal_code VARCHAR(15),
    country VARCHAR(50),
    country_code CHAR(2),
    web_page VARCHAR(200),
    notes TEXT,
    attachments TEXT,
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);

-- 2) Insert with cleaning rules
INSERT INTO Clean_Northwind.customers
(customer_id, company_name, company_short_name,
 first_name, last_name, full_name,
 email, job_title, 
 phone_business, phone_home, phone_mobile, phone_fax,
 street_address, city, state_code, state_name,
 postal_code, country, country_code, web_page,
 notes, attachments, record_start_date)
SELECT
  id,
  company,
  TRIM(REPLACE(company, 'Company', '')) AS company_short_name,
  first_name,
  last_name,
  CONCAT_WS(' ', first_name, last_name) AS full_name,
  COALESCE(NULLIF(email_address, ''), 'unknown@northwind.com') AS email,
  job_title,

  business_phone AS phone_business,
  COALESCE(NULLIF(home_phone, ''), business_phone) AS phone_home,
  COALESCE(NULLIF(mobile_phone, ''), business_phone) AS phone_mobile,
  fax_number AS phone_fax,

  address AS street_address,
  CASE WHEN city = 'Los Angelas' THEN 'Los Angeles' ELSE city END AS city,
  state_province AS state_code,
  CASE state_province
    WHEN 'WA' THEN 'Washington'
    WHEN 'MA' THEN 'Massachusetts'
    WHEN 'CA' THEN 'California'
    WHEN 'NY' THEN 'New York'
    WHEN 'MN' THEN 'Minnesota'
    WHEN 'WI' THEN 'Wisconsin'
    WHEN 'ID' THEN 'Idaho'
    WHEN 'OR' THEN 'Oregon'
    WHEN 'UT' THEN 'Utah'
    WHEN 'IL' THEN 'Illinois'
    ELSE state_province
  END AS state_name,
  zip_postal_code AS postal_code,
  'United States' AS country,
  'US' AS country_code,
  web_page,
  COALESCE(NULLIF(notes, ''), 'There are no notes') AS notes,
  COALESCE(NULLIF(CAST(attachments AS CHAR), ''), 'There are no attachments') AS attachments,
  CURRENT_DATE AS record_start_date
FROM Stg_Northwind.customers ;

SELECT * FROM Clean_Northwind.customers;
---------------------------------------------------------------------------------------------------------------------
-- 1) Create clean employee_privileges
CREATE TABLE IF NOT EXISTS Clean_Northwind.employee_privileges (
    employee_id INT NOT NULL,
    privilege_id INT NOT NULL,
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL,
    PRIMARY KEY (employee_id, privilege_id)
);

-- 2) Insert clean data
INSERT INTO Clean_Northwind.employee_privileges
(employee_id, privilege_id, record_start_date)
SELECT 
    employee_id,
    privilege_id,
    CURRENT_DATE AS record_start_date
FROM Stg_Northwind.employee_privileges ;

SELECT * FROM employee_privileges;
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) Create clean employee

CREATE TABLE IF NOT EXISTS Clean_Northwind.employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    full_name VARCHAR(120),
    email VARCHAR(100) DEFAULT 'unknown@northwind.com',
    job_title VARCHAR(100),
    phone_business VARCHAR(25),
    phone_home VARCHAR(25),
    phone_mobile VARCHAR(25),
    phone_fax VARCHAR(25),
    street_address VARCHAR(200),
    city VARCHAR(50),
    state_code VARCHAR(5),
    postal_code VARCHAR(15),
    country VARCHAR(50),
    web_page VARCHAR(200),
    notes TEXT,
    attachments TEXT,
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);

-- 2) Insert clean data
INSERT INTO Clean_Northwind.employees
(employee_id, first_name, last_name, full_name,
 email, job_title,
 phone_business, phone_home, phone_mobile, phone_fax,
 street_address, city, state_code, postal_code, country,
 web_page, notes, attachments, record_start_date)
SELECT 
    id,
    first_name,
    last_name,
    CONCAT_WS(' ', first_name, last_name) AS full_name,
    COALESCE(NULLIF(email_address,''), 'unknown@northwind.com') AS email,
    job_title,
    business_phone AS phone_business,
    COALESCE(NULLIF(home_phone,''), business_phone) AS phone_home,
    COALESCE(NULLIF(mobile_phone,''), business_phone) AS phone_mobile,
    fax_number AS phone_fax,
    address AS street_address,
    city,
    state_province AS state_code,
    zip_postal_code AS postal_code,
    country_region AS country,
    TRIM(SUBSTRING_INDEX(web_page,'#',1)) AS web_page,
    COALESCE(NULLIF(notes,''), 'There are no notes') AS notes,
    COALESCE(NULLIF(CAST(attachments AS CHAR),''), 'There are no attachments') AS attachments,
    CURRENT_DATE AS record_start_date
FROM Stg_Northwind.employees;

SELECT * FROM employees;
----------------------------------------------------------------------------------------------------
-- 1) Create clean inventory_transaction_types 
CREATE TABLE IF NOT EXISTS Clean_Northwind.inventory_transaction_types (
    transaction_type_id INT PRIMARY KEY,
    transaction_type_name VARCHAR(50),
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);

-- 2) Insert clean data
INSERT INTO Clean_Northwind.inventory_transaction_types
(transaction_type_id, transaction_type_name, record_start_date)
SELECT 
    id,
    type_name,  
    CURRENT_DATE
FROM Stg_Northwind.inventory_transaction_types;

SELECT * FROM inventory_transaction_types;
----------------------------------------------------------------------------------
-- 1) Create clean inventory_transaction
CREATE TABLE IF NOT EXISTS Clean_Northwind.inventory_transactions (
    transaction_id INT PRIMARY KEY,
    transaction_type_id INT,
    transaction_type_name VARCHAR(50),
    transaction_created_date DATETIME,
    transaction_modified_date DATETIME,
    product_id INT,
    quantity INT,
    purchase_order_id INT,
    customer_order_id INT,
    comments TEXT    
);


-- 2) Insert clean data
INSERT INTO Clean_Northwind.inventory_transactions
(transaction_id, transaction_type_id, transaction_type_name,
 transaction_created_date, transaction_modified_date,
 product_id, quantity, purchase_order_id, customer_order_id,
 comments)
SELECT 
    it.id,
    it.transaction_type,
    itt.transaction_type_name AS transaction_type_name,
    it.transaction_created_date,
    it.transaction_modified_date,
    it.product_id,
    it.quantity,
    it.purchase_order_id,
    it.customer_order_id,
    COALESCE(NULLIF(it.comments,''), 'No comments') AS comments
    FROM Stg_Northwind.inventory_transactions it
LEFT JOIN Clean_Northwind.inventory_transaction_types itt
       ON it.transaction_type = itt.transaction_type_id;
       
  SELECT * FROM inventory_transactions;     
------------------------------------------------------------------------------------------------------

-- 1) Create clean invoices table
CREATE TABLE IF NOT EXISTS Clean_Northwind.invoices (
    invoice_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    invoice_date DATETIME NOT NULL,
    due_date DATETIME,
    tax DECIMAL(10,4),
    shipping DECIMAL(10,4),
    amount_due DECIMAL(10,4)
);

-- 2) Insert clean data
INSERT INTO Clean_Northwind.invoices
(invoice_id, order_id, invoice_date, due_date, tax, shipping, amount_due)
SELECT 
    id AS invoice_id,
    order_id,
    invoice_date,
    -- if due_date is NULL, assume 30 days after invoice_date
    COALESCE(due_date, DATE_ADD(invoice_date, INTERVAL 30 DAY)) AS due_date,
    COALESCE(tax, 0.0000) AS tax,
    COALESCE(shipping, 0.0000) AS shipping,
    COALESCE(amount_due, 0.0000) AS amount_due
FROM Stg_Northwind.invoices ;

SELECT * FROM invoices;
------------------------------------------------------------------------------------------------
-- 1) Create clean Order_details table
CREATE TABLE IF NOT EXISTS Clean_Northwind.order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity DECIMAL(10,2),
    unit_price DECIMAL(10,4),
    discount DECIMAL(5,2),
    status_id INT,
    date_allocated DATETIME,
    purchase_order_id INT,
    inventory_id INT,
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);


-- 2) Insert clean data
INSERT INTO Clean_Northwind.order_details
(order_detail_id, order_id, product_id, quantity, unit_price, discount, status_id,
 date_allocated, purchase_order_id, inventory_id, record_start_date)
SELECT
    id,
    order_id,
    product_id,
    CASE WHEN quantity <= 0 THEN NULL ELSE quantity END AS quantity,
    COALESCE(unit_price, 0.0000) AS unit_price,
    COALESCE(discount, 0.00) AS discount,
    status_id,
    date_allocated,
    purchase_order_id,
    inventory_id,
    CURRENT_DATE
FROM Stg_Northwind.order_details;

SELECT * FROM Clean_Northwind.order_details;
-----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Clean_Northwind.order_details_status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50),
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);

INSERT INTO Clean_Northwind.order_details_status
(status_id, status_name, record_start_date)
SELECT
    id AS status_id,
    status_name,
    CURRENT_DATE
FROM Stg_Northwind.order_details_status;

SELECT * FROM Clean_Northwind.order_details_status;
-----------------------------------------------------------------------------------------------------
-- 1) Create clean orders table
CREATE TABLE IF NOT EXISTS Clean_Northwind.orders (
    order_id INT PRIMARY KEY,
    employee_id INT,
    customer_id INT,
    order_date DATETIME,
    shipped_date DATETIME,
    shipper_id INT,
    ship_name VARCHAR(100),
    ship_address VARCHAR(200),
    ship_city VARCHAR(50),
    ship_state_province VARCHAR(5),
    ship_zip_postal_code VARCHAR(15),
    ship_country_region VARCHAR(50),
    shipping_fee DECIMAL(10,4),
    taxes DECIMAL(10,4),
    payment_type VARCHAR(50),
    paid_date DATETIME,
    notes TEXT,
    tax_rate DECIMAL(5,4),
    tax_status_id INT,
    status_id INT,
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);

-- 2) Insert clean data from staging
INSERT INTO Clean_Northwind.orders
(order_id, employee_id, customer_id, order_date, shipped_date, shipper_id,
 ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code,
 ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes,
 tax_rate, tax_status_id, status_id, record_start_date)
SELECT
    id AS order_id,
    COALESCE(employee_id, 0) AS employee_id,                -- Replace NULL with 0 for FK
    COALESCE(customer_id, 0) AS customer_id,
    order_date,
    shipped_date,
    COALESCE(shipper_id, 0) AS shipper_id,
    TRIM(ship_name) AS ship_name,
    TRIM(ship_address) AS ship_address,
    CASE 
        WHEN ship_city = 'Los Angelas' THEN 'Los Angeles'
        ELSE TRIM(ship_city)
    END AS ship_city,                                        -- Fix common typos
    UPPER(TRIM(ship_state_province)) AS ship_state_province,
    ship_zip_postal_code,
    UPPER(TRIM(ship_country_region)) AS ship_country_region,
    COALESCE(shipping_fee, 0.0000) AS shipping_fee,         -- Replace NULL with 0
    COALESCE(taxes, 0.0000) AS taxes,
    CASE LOWER(payment_type)
        WHEN 'check' THEN 'Check'
        WHEN 'credit card' THEN 'Credit Card'
        ELSE 'Other'
    END AS payment_type,                                     -- Standardize payment types
    paid_date,
    COALESCE(NULLIF(TRIM(notes), ''), 'No notes') AS notes, -- Fill empty notes
    COALESCE(tax_rate, 0.0000) AS tax_rate,
    tax_status_id,
    status_id,
    CURRENT_DATE AS record_start_date
FROM Stg_Northwind.orders;



--------------------------------------------------------------------------------------------------------------------------
-- 1) Create Clean orders_status table
CREATE TABLE IF NOT EXISTS Clean_Northwind.orders_status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50)
    );


-- 2) Insert clean data
INSERT INTO Clean_Northwind.orders_status
(status_id, status_name)
SELECT
    id AS status_id,
    status_name
   FROM Stg_Northwind.orders_status;

SELECT * FROM Clean_Northwind.orders_status;
--------------------------------------------------------------------
-- 1) Create Clean orders_tax_status table
CREATE TABLE IF NOT EXISTS Clean_Northwind.orders_tax_status (
    tax_id INT PRIMARY KEY,
    tax_status_name VARCHAR(50)
    );

-- 2) Insert clean data
INSERT INTO Clean_Northwind.orders_tax_status
(tax_id, tax_status_name)
SELECT
    id AS tax_id,
    tax_status_name
   FROM Stg_Northwind.orders_tax_status;

SELECT * FROM Clean_Northwind.orders_tax_status;
-----------------------------------------------------------------------
-- 1) Create Clean privileges table
CREATE TABLE IF NOT EXISTS Clean_Northwind.privileges (
    privilege_id INT PRIMARY KEY,
    privilege_name VARCHAR(100)
    );

-- 2) Insert clean data 
INSERT INTO Clean_Northwind.privileges
(privilege_id, privilege_name)
SELECT
    id AS privilege_id,
    privilege_name
FROM Stg_Northwind.privileges;

SELECT * FROM Clean_Northwind.privileges;
------------------------------------------------------------------------------------------------------
-- 1) Create Clean products table
CREATE TABLE IF NOT EXISTS Clean_Northwind.products (
    product_id INT PRIMARY KEY,
    product_code VARCHAR(50),
    product_name VARCHAR(100),
    description VARCHAR(500),
    standard_cost DECIMAL(10,4),
    list_price DECIMAL(10,4),
    reorder_level INT,
    target_level INT,
    quantity_per_unit VARCHAR(50),
    discontinued INT,
    minimum_reorder_quantity INT,
    category VARCHAR(50),
    attachments VARCHAR(200)
   );

-- 2) Insert clean data
INSERT INTO Clean_Northwind.products
(product_id, product_code, product_name, description, standard_cost, list_price, reorder_level,
 target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments)
SELECT
    id AS product_id,
    product_code,
    product_name,
    COALESCE(NULLIF(description,''),'No description') AS description,
    COALESCE(standard_cost,0) AS standard_cost,
    COALESCE(list_price,0) AS list_price,
    COALESCE(reorder_level,0) AS reorder_level,
    COALESCE(target_level,0) AS target_level,
    COALESCE(NULLIF(quantity_per_unit,''),'Unknown') AS quantity_per_unit,
    discontinued,
    COALESCE(minimum_reorder_quantity,0) AS minimum_reorder_quantity,
    category,
    COALESCE(NULLIF(attachments,''),'No attachments') AS attachments
    FROM Stg_Northwind.products;
    -----------------------------------------------------------------------------------
-- 1) Create Clean purchase_order_details table
CREATE TABLE IF NOT EXISTS Clean_Northwind.purchase_order_details (
    purchase_order_detail_id INT PRIMARY KEY,
    purchase_order_id INT,
    product_id INT,
    quantity DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    date_received DATE,
    posted_to_inventory INT,
    inventory_id INT,
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);

INSERT INTO Clean_Northwind.purchase_order_details
(purchase_order_detail_id, purchase_order_id, product_id, quantity, unit_cost, date_received,
 posted_to_inventory, inventory_id, record_start_date)
SELECT
    id AS purchase_order_detail_id,
    purchase_order_id,
    product_id,
    CASE WHEN quantity <= 0 THEN NULL ELSE quantity END AS quantity,
    COALESCE(unit_cost,0) AS unit_cost,
    COALESCE(date_received,'1111-11-11') AS date_received,
    COALESCE(posted_to_inventory,0) AS posted_to_inventory,
    COALESCE(inventory_id,0) AS inventory_id,
    CURRENT_DATE
FROM Stg_Northwind.purchase_order_details;

SELECT * FROM purchase_order_details;
-----------------------------------------------------------------------------------------------------------------
-- 1)Create clean purchase_order_status table 
CREATE TABLE IF NOT EXISTS Clean_Northwind.purchase_order_status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50)
);

-- 2) Insert cleaning data 
INSERT INTO Clean_Northwind.purchase_order_status (status_id, status_name)
SELECT 
    id AS status_id,
    status AS status_name
FROM Stg_Northwind.purchase_order_status;

SELECT * FROM purchase_order_status;
------------------------------------------------------------------------------------------------------------
-- 1) Create Clean purchase_orders table
CREATE TABLE IF NOT EXISTS Clean_Northwind.purchase_orders (
    purchase_order_id INT PRIMARY KEY,
    supplier_id INT,
    created_by INT,
    submitted_date DATE,
    creation_date DATE,
    status_id INT,
    expected_date DATE,
    shipping_fee DECIMAL(10,2),
    taxes DECIMAL(10,2),
    payment_date DATE,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    notes VARCHAR(500),
    approved_by INT,
    approved_date DATE,
    submitted_by INT,
    record_start_date DATE DEFAULT (CURRENT_DATE),
    record_end_date DATE NULL
);

-- 2) Insert cleaned data 
INSERT INTO Clean_Northwind.purchase_orders
(
    purchase_order_id, supplier_id, created_by, submitted_date, creation_date, status_id,
    expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method,
    notes, approved_by, approved_date, submitted_by, record_start_date
)
SELECT
    id AS purchase_order_id,
    COALESCE(supplier_id, 0) AS supplier_id,
    COALESCE(created_by, 0) AS created_by,
    COALESCE(submitted_date, '1111-11-11') AS submitted_date,
    COALESCE(creation_date, '1111-11-11') AS creation_date,
    COALESCE(status_id, 0) AS status_id,
    COALESCE(expected_date, '1111-11-11') AS expected_date,
    COALESCE(shipping_fee, 0.0000) AS shipping_fee,
    COALESCE(taxes, 0.0000) AS taxes,
    COALESCE(payment_date, '1111-11-11') AS payment_date,
    COALESCE(payment_amount, 0.0000) AS payment_amount,
    COALESCE(payment_method, 'Other') AS payment_method,
    COALESCE(notes, 'No notes') AS notes,
    COALESCE(approved_by, 0) AS approved_by,
    COALESCE(approved_date, '1111-11-11') AS approved_date,
    COALESCE(submitted_by, 0) AS submitted_by,
    CURRENT_DATE AS record_start_date
FROM Stg_Northwind.purchase_orders;

SELECT * FROM purchase_orders;
-----------------------------------------------------------------------------------------

-- 1) Create Clean shippers table
CREATE TABLE IF NOT EXISTS Clean_Northwind.shippers (
    shipper_id INT PRIMARY KEY,
    company VARCHAR(200),
    last_name VARCHAR(100),
    first_name VARCHAR(100),
    email_address VARCHAR(100),
    job_title VARCHAR(100),
    business_phone VARCHAR(50),
    home_phone VARCHAR(50),
    mobile_phone VARCHAR(50),
    fax_number VARCHAR(50),
    address VARCHAR(200),
    city VARCHAR(100),
    state_province VARCHAR(50),
    zip_postal_code VARCHAR(20),
    country_region VARCHAR(50),
    web_page VARCHAR(200),
    notes TEXT,
    attachments TEXT
);

-- 2) Insert cleaned data from staging
INSERT INTO Clean_Northwind.shippers
(shipper_id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments)
SELECT
    id AS shipper_id,
    COALESCE(company,'Unknown') AS company,
    COALESCE(NULLIF(TRIM(last_name),''),'Unknown') AS last_name,
    COALESCE(NULLIF(TRIM(first_name),''),'Unknown') AS first_name,
    COALESCE(NULLIF(TRIM(email_address),''),'No info') AS email_address,
    COALESCE(NULLIF(TRIM(job_title),''),'No info') AS job_title,
    COALESCE(NULLIF(TRIM(business_phone),''),'000-000-0000') AS business_phone,
    COALESCE(NULLIF(TRIM(home_phone),''),'000-000-0000') AS home_phone,
    COALESCE(NULLIF(TRIM(mobile_phone),''),'000-000-0000') AS mobile_phone,
    COALESCE(NULLIF(TRIM(fax_number),''),'000-000-0000') AS fax_number,
    COALESCE(NULLIF(TRIM(address),''),'Unknown') AS address,
    COALESCE(NULLIF(UPPER(TRIM(city)),'') ,'Unknown') AS city,
    COALESCE(NULLIF(UPPER(TRIM(state_province)),'') ,'Unknown') AS state_province,
    COALESCE(NULLIF(TRIM(zip_postal_code),''),'Unknown') AS zip_postal_code,
    COALESCE(NULLIF(UPPER(TRIM(country_region)),'') ,'Unknown') AS country_region,
    COALESCE(NULLIF(TRIM(web_page),''),'No info') AS web_page,
    COALESCE(NULLIF(TRIM(notes),''),'No info') AS notes,
    COALESCE(NULLIF(TRIM(attachments),''),'No attach') AS attachments
FROM Stg_Northwind.shippers;

SELECT * FROM shippers;
-----------------------------------------------------------------------------------------------------------------------
-- 1) Create Clean strings table
CREATE TABLE IF NOT EXISTS Clean_Northwind.strings (
    string_id INT PRIMARY KEY,
    string_data TEXT
);

-- 2) Insert cleaned data
INSERT INTO Clean_Northwind.strings (string_id, string_data)
SELECT
    string_id,
    COALESCE(NULLIF(TRIM(string_data),''), 'No message') AS string_data
FROM Stg_Northwind.strings;

SELECT * FROM strings;
-------------------------------------------------------------------------

-- 1) Create Clean suppliers table
CREATE TABLE IF NOT EXISTS Clean_Northwind.suppliers (
    supplier_id INT PRIMARY KEY,
    company TEXT,
    last_name TEXT,
    first_name TEXT,
    email VARCHAR(100) DEFAULT 'unknown@northwind.com',
    job_title TEXT,
    business_phone TEXT,
    home_phone TEXT,
    mobile_phone TEXT,
    fax_number TEXT,
    address TEXT,
    city TEXT,
    state_province TEXT,
    zip_postal_code TEXT,
    country_region TEXT,
    web_page TEXT,
    notes TEXT,
    attachments TEXT
);

-- 2) Insert cleaned data
INSERT INTO Clean_Northwind.suppliers (
    supplier_id, company, last_name, first_name,email, job_title,
    business_phone, home_phone, mobile_phone, fax_number, address,
    city, state_province, zip_postal_code, country_region, web_page, notes, attachments
)
SELECT
    id AS supplier_id,
    TRIM(company) AS company,
    TRIM(last_name) AS last_name,
    TRIM(first_name) AS first_name,
    COALESCE(NULLIF(email_address,''), 'unknown@northwind.com') AS email,
    TRIM(job_title) AS job_title,
    COALESCE(TRIM(business_phone), '000-000-0000') AS business_phone,
    COALESCE(TRIM(home_phone), '000-000-0000') AS home_phone,
    COALESCE(TRIM(mobile_phone), '000-000-0000') AS mobile_phone,
    COALESCE(TRIM(fax_number), '000-000-0000') AS fax_number,
    COALESCE(TRIM(address), 'Unknown address') AS address,
    COALESCE(TRIM(city), 'Unknown city ') AS city,
    COALESCE(TRIM(state_province), 'Unknown') AS state_province,
    COALESCE(TRIM(zip_postal_code), 'Unknown') AS zip_postal_code,
    COALESCE(TRIM(country_region), 'Unknown region') AS country_region,
    COALESCE(TRIM(web_page), 'no content ') AS web_page,
    COALESCE(TRIM(notes), 'ther is no notes ') AS notes,
    COALESCE(NULLIF(TRIM(attachments),''),'No attach') AS attachments
FROM Stg_Northwind.suppliers;

SELECT * FROM suppliers;




