# Data Transformation and Preparation

## 1. Objective

The objective of this phase is to prepare the cleaned Olist e-commerce dataset for reliable business analysis and reporting.

Following the data quality assessment and cleaning phases, this stage focuses on organising the cleaned data, establishing appropriate table relationships, preparing analytical datasets, and creating derived fields required to investigate business and operational performance.

The goal is to ensure that the data is structured appropriately for SQL-based exploratory data analysis (EDA), business KPI development, and Power BI dashboard development.

## 2. Scope of Work

This phase will cover the following activities:

- **Table Relationship Preparation:** Identify and establish appropriate relationships between orders, order items, products, payments, reviews, customers, and sellers.
- **Derived Field Creation:** Prepare relevant analytical fields, such as delivery duration and order value, where supported by the available data.
- **Analytical Dataset Preparation:** Organise data at the appropriate level of detail for specific business questions.
- **SQL View Development:** Create reusable SQL views where they improve analytical consistency and simplify reporting.
- **Data Validation:** Verify row counts, join behaviour, calculations, and aggregation logic to reduce the risk of duplicate counting or misleading results.
- **Power BI Readiness:** Prepare the data and relationships required for subsequent dashboard development.

## 3. Tables in Scope

The project contains the following source datasets and cleaned tables relevant to the preparation process:

- Orders
- Order items
- Products
- Order payments
- Order reviews
- Customers
- Sellers
- Geolocation
- Product category translation

The existing cleaned tables will be reused where appropriate. Additional transformations or analytical views will be created only when required by the analysis.

## 4. Analytical Objectives

The prepared datasets will support investigations into:

- Sales and order performance
- Product category performance
- Order fulfilment and delivery duration
- Freight costs and logistics performance
- Payment methods and payment values
- Customer review scores
- Order cancellations and operational exceptions

## 5. Data Integrity Principles

The transformation process will follow these principles:

1. Preserve the original source data.
2. Reuse documented cleaning decisions rather than repeating completed cleaning activities.
3. Avoid modifying valid source values without a justified reason.
4. Handle missing timestamps and unresolved source anomalies transparently.
5. Validate table joins and aggregation logic before calculating business metrics.
6. Document significant transformations and their intended analytical purpose.

## 6. Expected Outcome

The expected outcome is a set of appropriately prepared datasets, derived fields, and reusable SQL views that support reliable exploratory data analysis, business KPI development, and Power BI reporting.

## 7. Project Status

**Status:** In progress

The specific transformations, SQL queries, validation results, and analytical views will be documented as this phase progresses.

## 8. Next Phase

Upon completion of data transformation and preparation, the project will proceed to **Exploratory Data Analysis (EDA)** to investigate business questions and identify patterns, trends, and potential operational improvement opportunities.
