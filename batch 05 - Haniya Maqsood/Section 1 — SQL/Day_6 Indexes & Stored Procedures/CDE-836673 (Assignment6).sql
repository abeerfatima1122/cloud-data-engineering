-- ============================================================
--  PART A: INDEXES
-- ============================================================

-- Q1.
-- Create a non-clustered index on last_name

CREATE NONCLUSTERED INDEX IX_Customers_LastName
ON sales.customers(last_name);

-- Query that benefits from this index

SELECT *
FROM sales.customers
WHERE last_name = 'Smith';



-- Q2.
-- Create a composite index on customer_id and order_date

CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_OrderDate
ON sales.orders(customer_id, order_date);

-- Query that benefits from this index

SELECT *
FROM sales.orders
WHERE customer_id = 5
AND order_date = '2018-01-01';



-- Q3.
/*
A unique index on sales.customers(phone_number) could fail if:

1. Duplicate phone numbers already exist.
2. Multiple customers have NULL phone numbers.

For this to be safe:
- Every customer must have a unique phone number.
- No duplicate values should exist in the column.
*/



-- Q4.
/*
order_id (Primary Key)
-> SHOULD have an index.
-> Primary keys are automatically indexed and frequently used for lookups.

status
-> SHOULD NOT have a separate index.
-> Only 3 possible values (Pending, Shipped, Delivered), so selectivity is low.

customer_id (Foreign Key)
-> SHOULD have an index.
-> Frequently used in joins and searches.

notes
-> SHOULD NOT have a regular index.
-> Free-text column, rarely searched, large storage overhead.
*/



-- Q5.
-- Check existing indexes

EXEC sp_helpindex 'production.products';

-- Output Explanation:
/*
index_name      = Name of the index
index_description = Type of index (clustered, nonclustered, unique, etc.)
index_keys      = Columns included in the index
*/



-- ============================================================
--  PART B: STORED PROCEDURES
-- ============================================================

-- Q6.
-- Create stored procedure

CREATE PROCEDURE sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SELECT
        order_id,
        order_date,
        order_status
    FROM sales.orders
    WHERE customer_id = @CustomerID;
END;
GO

-- Test procedure

EXEC sp_GetCustomerOrders 1;
GO



-- Q7.
-- Modified procedure with message when no orders exist

CREATE OR ALTER PROCEDURE sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM sales.orders
        WHERE customer_id = @CustomerID
    )
    BEGIN
        SELECT
            order_id,
            order_date,
            order_status
        FROM sales.orders
        WHERE customer_id = @CustomerID;
    END
    ELSE
    BEGIN
        PRINT 'No orders found for this customer';
    END
END;
GO

-- Test

EXEC sp_GetCustomerOrders 99999;
GO



-- Q8.
-- Products by Category with default MaxPrice

CREATE PROCEDURE sp_ProductsByCategory
    @CategoryID INT,
    @MaxPrice DECIMAL(10,2) = 9999
AS
BEGIN
    SELECT
        product_id,
        product_name,
        list_price
    FROM production.products
    WHERE category_id = @CategoryID
      AND list_price <= @MaxPrice
    ORDER BY list_price ASC;
END;
GO

-- Test examples

EXEC sp_ProductsByCategory 1;

EXEC sp_ProductsByCategory
     @CategoryID = 1,
     @MaxPrice = 1000;
GO



-- ============================================================
--  PART C: MIXED / THINK QUESTIONS
-- ============================================================

-- Q9.
/*
Two things I would do:

1. Create an index on (store_id, order_date)
   because these columns are used in the WHERE clause
   and indexing will reduce table scans.

2. Review and optimize the stored procedure logic
   by avoiding SELECT *, returning only required columns,
   and ensuring unnecessary calculations or loops are removed.

These changes improve query performance and reduce execution time.
*/



-- Q10.
/*
Creating indexes on every column is a bad idea because indexes
consume extra storage space and increase maintenance costs.
Whenever INSERT, UPDATE, or DELETE operations occur, SQL Server
must also update all related indexes. Too many indexes can slow
down write operations significantly. Indexes should only be
created on columns that are frequently searched, filtered, joined,
or sorted.
*/