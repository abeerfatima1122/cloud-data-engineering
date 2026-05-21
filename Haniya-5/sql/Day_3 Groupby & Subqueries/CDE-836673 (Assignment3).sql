
-- SQL Server — Class 3 Homework
-- Topics: GROUP BY · HAVING · Subqueries · EXISTS


-- Q1: Count how many products each brand has in the catalog.
-- Show brand name and product count.
-- Sort by count descending.

SELECT 
    b.brand_name,
    COUNT(p.product_id) AS product_count
FROM production.brands b
JOIN production.products p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY product_count DESC;



-- Q2: For each category, show:
-- category name,
-- total number of products,
-- cheapest price,
-- most expensive price,
-- average price (rounded to 2 decimals).
-- Sort by average price descending.

SELECT 
    c.category_name,
    COUNT(p.product_id) AS total_products,
    MIN(p.list_price) AS cheapest_price,
    MAX(p.list_price) AS most_expensive_price,
    ROUND(AVG(p.list_price), 2) AS average_price
FROM production.categories c
JOIN production.products p
    ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY average_price DESC;



-- Q3: Show the number of orders placed per order status.
-- Display the status value and order count.
-- Sort by order_status ascending.

SELECT 
    order_status,
    COUNT(order_id) AS order_count
FROM sales.orders
GROUP BY order_status
ORDER BY order_status ASC;



-- Q4: For each store, calculate total revenue:
-- (quantity × list_price × (1 – discount)) from order_items.
-- Show store name and total revenue.
-- Sort by revenue descending.

SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores s
JOIN sales.orders o
    ON s.store_id = o.store_id
JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;



-- Q5: Show total number of products per brand per model year.
-- Display brand name, model year, and product count.
-- Sort by brand name then model year.

SELECT 
    b.brand_name,
    p.model_year,
    COUNT(p.product_id) AS product_count
FROM production.brands b
JOIN production.products p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name, p.model_year
ORDER BY b.brand_name, p.model_year;



-- Q6: Find all brands that have more than 25 products in the catalog.
-- Show brand name and product count.

SELECT 
    b.brand_name,
    COUNT(p.product_id) AS product_count
FROM production.brands b
JOIN production.products p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 25;



-- Q7: Among products from year 2018 only,
-- find categories whose average price is above $1500.
-- Show category name, product count, and average price.

SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count,
    ROUND(AVG(p.list_price), 2) AS average_price
FROM production.categories c
JOIN production.products p
    ON c.category_id = p.category_id
WHERE p.model_year = 2018
GROUP BY c.category_name
HAVING AVG(p.list_price) > 1500;



-- Q8: Find customers who have placed 3 or more orders.
-- Show customer full name and order count.
-- Sort by order count descending.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id
GROUP BY c.first_name, c.last_name
HAVING COUNT(o.order_id) >= 3
ORDER BY order_count DESC;



-- Q9: Find all products whose list price is higher than
-- the average list price of all products.
-- Show product name and price.
-- Sort by price descending.

SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products
)
ORDER BY list_price DESC;



-- Q10: Find all orders placed by customers from state 'TX'.
-- Use a subquery (NOT a JOIN).
-- Show order ID, customer ID, and order date.

SELECT 
    order_id,
    customer_id,
    order_date
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state = 'TX'
);



-- Q11: For each brand, show its average price,
-- but only for brands whose average price exceeds overall product average.
-- Use a subquery in FROM (derived table).
-- Show brand name and average price.

SELECT *
FROM (
    SELECT 
        b.brand_name,
        AVG(p.list_price) AS average_price
    FROM production.brands b
    JOIN production.products p
        ON b.brand_id = p.brand_id
    GROUP BY b.brand_name
) AS brand_avg
WHERE average_price > (
    SELECT AVG(list_price)
    FROM production.products
);



-- Q12: Using EXISTS:
-- Find all customers who have placed at least one order.
-- Show customer full name and email.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.email
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);



-- Q13: Using NOT EXISTS:
-- Find all products that have never appeared in any order (order_items).
-- Show product name and list price.

SELECT 
    p.product_name,
    p.list_price
FROM production.products p
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.order_items oi
    WHERE oi.product_id = p.product_id
);

