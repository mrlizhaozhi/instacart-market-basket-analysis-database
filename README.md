# InstaCart Market Basket Analysis Database Schema

This schema turns the InstaCart market basket analysis dataset available at [Kaggle](https://www.kaggle.com/datasets/yasserh/instacart-online-grocery-basket-analysis-dataset) into a relational database using the PostgreSQL dialect.

This dataset is good for practising SQL and Python for CRM/marketing analytics.

## Instructions

Step 1: Download the dataset from Kaggle.

Step 2: Fire up pgAdmin and create a new database. Note that IF NOT EXISTS does not work in older PostgreSQL. Do this manually and comment out the database creation code in the SQL script if necessary.

Step 3: Navigate to Step 3 in the SQL script and update the paths to the downloaded data files then run the script to create the database structure and import data.

Step 4: Test the database setup by running sanity checks.

## Database schema

![instacart database schema image](https://github.com/mrlizhaozhi/instacart-market-basket-analysis-database/blob/main/instacart_database_schema.png)

The SQL script combines `order_product__prior` and `order_product__train` into a single `order_product` table.