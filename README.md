# Retail-Analytics-Database-Management-SQL

This repository contains a complete SQL-based database management project for a convenience retail dataset.  
It includes the logical data model, physical schema, data import steps, and SQL queries created to answer specific business decisions.

The project demonstrates database design, normalization, ETL, and analytical querying for retail insights.



## Project Overview

This project was completed for a Database Management course and follows a full database lifecycle:

1. Logical data model design  
2. Physical schema creation in MySQL  
3. Data loading using Import Wizard  
4. Business decision analysis using SQL queries  
5. Final insights and reporting  

The dataset includes store information, transactions, products, promotions, and customer attributes.

<img width="640" height="685" alt="Screenshot 2025-11-30 at 8 45 56 PM" src="https://github.com/user-attachments/assets/3e033569-3b0e-4660-9986-1819441e762d" />


## Business Decisions Addressed

The project includes SQL solutions for several business questions such as:

- Identifying stores with the fewest transactions  
- Ranking products by sales volume  
- Analyzing category-level performance  
- Understanding seasonal or regional patterns  

The SQL queries and outputs are included in the repository.



## Logical Model Adjustments

During implementation, several data type adjustments were made for descriptive fields:

| Table | Column | Change |
|-------|--------|--------|
| Product Category | CategoryDESC | VARCHAR 45 → 55 |
| Product SubCategory | SubCatDESC | VARCHAR 45 → 65 |
| Product Group | ProductGroupDESC | VARCHAR 45 → 70 |
| Product | ProductDESC | VARCHAR 45 → 70 |
| Store Master | Region | VARCHAR 45 → 10 |

These adjustments were made to improve data consistency and storage efficiency after importing real data.



## Tools Used

- MySQL Workbench  
- Import Wizard for data loading  
- SQL SELECT, JOIN, GROUP BY, ORDER BY, HAVING  
- ERD modeling tools
  

## Insights Summary

This project provides several retail insights such as:

- Small or low-traffic stores can be identified for operational review
- High-performing categories reveal assortment opportunities
- Regional transaction differences highlight demand patterns
- Store-level and product-level analytics support data-driven retail decisions

## Purpose of This Project

This project showcases skills in:

- SQL database design
- Data modeling and schema normalization
- ETL using MySQL Import Wizard
- Writing analytical queries
- Translating SQL results into business decisions
