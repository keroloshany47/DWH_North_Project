-- 1. Create Staging Schema
CREATE SCHEMA IF NOT EXISTS Stg_Northwind;

-- 2. Copy all tables into Stg_Northwind schema (with data)

CREATE TABLE Stg_Northwind.customers AS SELECT * FROM northwind.customers;
CREATE TABLE Stg_Northwind.employees AS SELECT * FROM northwind.employees;
CREATE TABLE Stg_Northwind.privileges AS SELECT * FROM northwind.privileges;
CREATE TABLE Stg_Northwind.employee_privileges AS SELECT * FROM northwind.employee_privileges;
CREATE TABLE Stg_Northwind.inventory_transaction_types AS SELECT * FROM northwind.inventory_transaction_types;
CREATE TABLE Stg_Northwind.shippers AS SELECT * FROM northwind.shippers;
CREATE TABLE Stg_Northwind.orders_tax_status AS SELECT * FROM northwind.orders_tax_status;
CREATE TABLE Stg_Northwind.orders_status AS SELECT * FROM northwind.orders_status;
CREATE TABLE Stg_Northwind.orders AS SELECT * FROM northwind.orders;
CREATE TABLE Stg_Northwind.products AS SELECT * FROM northwind.products;
CREATE TABLE Stg_Northwind.purchase_order_status AS SELECT * FROM northwind.purchase_order_status;
CREATE TABLE Stg_Northwind.suppliers AS SELECT * FROM northwind.suppliers;
CREATE TABLE Stg_Northwind.purchase_orders AS SELECT * FROM northwind.purchase_orders;
CREATE TABLE Stg_Northwind.inventory_transactions AS SELECT * FROM northwind.inventory_transactions;
CREATE TABLE Stg_Northwind.invoices AS SELECT * FROM northwind.invoices;
CREATE TABLE Stg_Northwind.order_details_status AS SELECT * FROM northwind.order_details_status;
CREATE TABLE Stg_Northwind.order_details AS SELECT * FROM northwind.order_details;
CREATE TABLE Stg_Northwind.purchase_order_details AS SELECT * FROM northwind.purchase_order_details;
CREATE TABLE Stg_Northwind.sales_reports AS SELECT * FROM northwind.sales_reports;
CREATE TABLE Stg_Northwind.strings AS SELECT * FROM northwind.strings;
