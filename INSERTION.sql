
USE northwind_dwh;

-- =====================
-- DIMENSION DATE
-- =====================
INSERT IGNORE INTO dim_date (
    date_key, full_date, day, day_name, month, month_name, quarter, year, is_weekend
)
SELECT DISTINCT
    DATE_FORMAT(d.dt, '%Y%m%d') AS date_key,
    d.dt AS full_date,
    DAY(d.dt) AS day,
    DAYNAME(d.dt) AS day_name,
    MONTH(d.dt) AS month,
    MONTHNAME(d.dt) AS month_name,
    QUARTER(d.dt) AS quarter,
    YEAR(d.dt) AS year,
    CASE WHEN DAYOFWEEK(d.dt) IN (1,7) THEN 'Y' ELSE 'N' END AS is_weekend
FROM (
        SELECT order_date AS dt FROM clean_northwind.orders
        UNION ALL
        SELECT shipped_date FROM clean_northwind.orders
        UNION ALL
        SELECT paid_date FROM clean_northwind.orders
        UNION ALL
        SELECT record_start_date FROM clean_northwind.orders
        UNION ALL
        SELECT record_end_date FROM clean_northwind.orders
        UNION ALL
        SELECT invoice_date FROM clean_northwind.invoices
        UNION ALL
        SELECT due_date FROM clean_northwind.invoices
        UNION ALL
        SELECT transaction_created_date FROM clean_northwind.inventory_transactions
        UNION ALL
        SELECT transaction_modified_date FROM clean_northwind.inventory_transactions
        UNION ALL
        SELECT record_start_date FROM clean_northwind.order_details
        UNION ALL
        SELECT record_end_date FROM clean_northwind.order_details
        UNION ALL
        SELECT date_allocated FROM clean_northwind.order_details
        UNION ALL
        SELECT record_start_date FROM clean_northwind.employees
        UNION ALL
        SELECT record_end_date FROM clean_northwind.employees
) AS d
WHERE d.dt >= '1970-01-01'
  AND d.dt IS NOT NULL;


-- =====================
-- DIMENSION SUPPLIER 
-- =====================
INSERT INTO dim_supplier(
	supplier_id, supplier_name,
    supplier_contact, supplier_email, supplier_phone,
    supplier_fax, supplier_address, supplier_city, supplier_region
)
SELECT DISTINCT 
	s.supplier_id,
    CONCAT(s.first_name , ' ' , s.last_name) , s.business_phone,
    s.email, s.mobile_phone, s.fax_number,
    s.address, s.city, s.country_region
FROM clean_northwind.suppliers AS s;
-- =====================
-- DIMENSION STATUS
-- =====================
INSERT INTO dim_status(status_id, status_name)
SELECT DISTINCT 
    ods.status_id,
    ods.status_name
FROM clean_northwind.order_details_status AS ods;

-- =====================
-- DIMENSION SHIPPER
-- =====================
INSERT INTO dim_shipper(shipper_id, company_name, phone)
SELECT DISTINCT 
    s.shipper_id,
    s.company,
    s.mobile_phone
FROM clean_northwind.shippers AS s;

-- =====================
-- DIMENSION PRODUCT 
-- =====================
INSERT INTO dim_product(
	product_id, product_code, product_name,
    description, standard_cost, list_price,
    reorder_level, target_level, quantity_per_unit,
    discontinued, minimum_reorder_qty, category,
    attachments
)
SELECT DISTINCT 
	p.product_id, p.product_code, p.product_name,
    p.description, p.standard_cost, p.list_price,
    p.reorder_level, p.target_level, p.quantity_per_unit,
    p.discontinued, p.minimum_reorder_quantity, 
    p.category, p.attachments
FROM clean_northwind.products AS p;

-- =====================
-- DIMENSION CUSTOMER
-- =====================
INSERT INTO dim_customer(
	customer_id , company_name , contact_name ,
	email_address , job_title ,
	business_phone , home_phone , mobile_phone ,
	fax_number , address , city ,
	region , postal_code , country , web_page
)
SELECT DISTINCT 
	c.customer_id, c.company_name, c.full_name,
    c.email, c.job_title,
    c.phone_business, c.phone_home, c.phone_mobile,
    c.phone_fax, c.street_address, c.city, 
    c.state_name, c.postal_code, c.country, c.web_page
FROM clean_northwind.customers AS c;

-- =====================
-- DIMENSION EMPLOYEE
-- =====================
INSERT INTO dim_employee(
	employee_id, last_name,
	first_name, email_address, job_title,
    business_phone, home_phone, mobile_phone,
    fax_number, address, city, 
    postal_code, country,
    web_page, hire_date, termination_date
)
SELECT DISTINCT 
	e.employee_id, e.last_name, e.first_name, 
    e.email, e.job_title, e.phone_business,
    e.phone_home, e.phone_mobile, e.phone_fax,
    e.street_address, e.city, e.postal_code,
    e.country, e.web_page, e.record_start_date, e.record_end_date
FROM clean_northwind.employees AS e;

-- =====================
-- FACT SALES
-- =====================
INSERT INTO fact_sales (
    order_date_key,
    shipped_date_key,
    paid_date_key,
    product_key,
    customer_key,
    employee_key,
    shipper_key,
    status_key,
    order_id,
    order_line_id,
    quantity,
    unit_price,
    discount,
    tax_rate,
    sales_amount
)
SELECT  
    dd_order.date_key   AS order_date_key,
    dd_ship.date_key    AS shipped_date_key,
    dd_paid.date_key    AS paid_date_key,
    dp.product_key,
    dc.customer_key,
    de.employee_key,
    dsh.shipper_key,
    dst.status_key,
    ods.order_id,
    od.order_detail_id,
    od.quantity,
    od.unit_price,
    od.discount,
    ods.tax_rate,
    (od.quantity * od.unit_price) 
      - od.discount 
      + (ods.tax_rate * (od.quantity * od.unit_price)) AS sales_amount
FROM clean_northwind.order_details AS od
JOIN clean_northwind.orders AS ods
  ON od.order_id = ods.order_id
JOIN dim_customer dc   ON dc.customer_id  = ods.customer_id
JOIN dim_employee de   ON de.employee_id  = ods.employee_id
JOIN dim_product dp    ON dp.product_id   = od.product_id
JOIN dim_shipper dsh   ON dsh.shipper_id  = ods.shipper_id
JOIN dim_status dst    ON dst.status_id   = ods.status_id
LEFT JOIN dim_date dd_order ON dd_order.full_date = ods.order_date
LEFT JOIN dim_date dd_ship  ON dd_ship.full_date  = ods.shipped_date
LEFT JOIN dim_date dd_paid  ON dd_paid.full_date  = ods.paid_date;
