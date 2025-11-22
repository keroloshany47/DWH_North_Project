# Northwind Data Warehouse

This project delivers a fully cleaned, standardized, and analytics-ready **Data Warehouse** based on the classic **Northwind** dataset. The goal is to transform raw transactional data into a reliable, consistent, and business-focused analytical model.

---

##  Project Purpose

* Improve data quality and consistency across all Northwind tables.
* Apply business-friendly transformations and standardization rules.
* Implement SCD Type 1 & Type 2 for historical tracking.
* Prepare the data for reporting, BI dashboards, and advanced analytics.

---

##  Project Structure

```
Northwind_DWH/
├── Source/                 # Original raw data
├── Clean_Script.sql        # Scripts for cleaning and transforming raw data
├── Stg_Script.sql          # Scripts for loading staging tables
├── DDL.sql                 # Data Definition Language scripts for warehouse tables
├── INSERTION.sql           # Data insertion scripts
├── Cleaning_report.pdf     # Report summarizing cleaning steps and transformations
└── README.md               # Project documentation
```

---

##  Key Cleaning & Standardization Highlights

* Normalized text fields (names, cities, states, countries).
* Filled missing emails, phones, descriptions, and notes with consistent defaults.
* Corrected city errors (e.g., *Los Angelas → Los Angeles*).
* Standardized numeric fields across orders, products, and purchase modules.
* Added derived fields (full name, company short name, state full name).
* Ensured referential integrity across all transactional tables.
* Implemented **SCD Type 1** for stable dimensions and **SCD Type 2** for historically changing data.

---

##  Main Dimensions Cleaned

* **Customers**: full standardization, default values, business rules, SCD Type 1.
* **Employees & Privileges**: relationship cleanup, SCD Type 2, URL & phone fixes.
* **Products & Suppliers**: cleaned attributes, numeric fields validation, default descriptions.
* **Shippers**: unified structure with fallback phone/address rules.

---

##  Main Facts Processed

* **Orders & Order Details**: pricing defaults, standardized payment types, corrected location data.
* **Purchase Orders & Details**: fixed dates, numeric corrections, SCD Type 2.
* **Inventory Transactions**: enriched with transaction type descriptions, cleaned comments.
* **Invoices**: enforced due dates, resolved NULL amounts.

---

##  Next Steps (Optional Enhancements)

* Build star schema fact tables (Sales, Inventory, Purchasing).
* Create Data Quality dashboards.
* Automate ETL using Python, SSIS, or Airflow.
* Build Power BI reports.

---

##  Summary

This project transforms the raw Northwind dataset into a professional-grade Data Warehouse with clean dimensions, validated facts, and consistent modeling rules—ready for analytics, reporting, and business insights.
