-- Q1
-- Show all product names along with their brand name.
-- Sort by brand name, then by product name alphabetically.

SELECT 
    p.product_name,
    b.brand_name
FROM production.products p
JOIN production.brands b
    ON p.brand_id = b.brand_id
ORDER BY b.brand_name, p.product_name;


-- Q2
-- List all products with their category name and list price.
-- Sort by category name, then by price ascending.

SELECT 
    p.product_name,
    c.category_name,
    p.list_price
FROM production.products p
JOIN production.categories c
    ON p.category_id = c.category_id
ORDER BY c.category_name, p.list_price ASC;

-- Q3
-- Show all orders with the customer's full name and order date.
-- Sort by newest order date.

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.orders o
JOIN sales.customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

-- Q4
-- Display each order item with product name, quantity,
-- unit price, and Line Total.

SELECT 
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.list_price AS unit_price,
    (oi.quantity * oi.list_price) AS [Line Total]
FROM sales.order_items oi
JOIN production.products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_id;

-- Q5
-- Show each order with store name and order date.

SELECT 
    o.order_id,
    s.store_name,
    o.order_date
FROM sales.orders o
JOIN sales.stores s
    ON o.store_id = s.store_id
ORDER BY s.store_name;

-- Q6
-- Show order ID, customer name, store name,
-- and staff member who handled the order.

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders o
JOIN sales.customers c
    ON o.customer_id = c.customer_id
JOIN sales.stores s
    ON o.store_id = s.store_id
JOIN sales.staffs st
    ON o.staff_id = st.staff_id;


    -- Q8
-- Find customers from NY who placed at least one order.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    o.order_date
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE c.state = 'NY'
ORDER BY o.order_date;

-- Q9
-- Show completed orders from Rowlett Bikes.

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.orders o
JOIN sales.customers c
    ON o.customer_id = c.customer_id
JOIN sales.stores s
    ON o.store_id = s.store_id
WHERE o.order_status = 4
AND s.store_name = 'Rowlett Bikes';

-- Q10
-- List all customers and any orders they placed.
-- Include customers with no orders.

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_id,
    o.order_date
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- Q11
-- Find customers who never placed an order.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q12
-- List all products and stock quantity at every store.
-- Include products with no stock record.

SELECT 
    p.product_name,
    st.store_id,
    st.quantity
FROM production.products p
LEFT JOIN production.stocks st
    ON p.product_id = st.product_id
ORDER BY p.product_name;

-- Q13
-- Find products never ordered.

SELECT 
    p.product_name,
    p.list_price
FROM production.products p
LEFT JOIN sales.order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Q14
-- List staff members with their manager names.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
    ON s.manager_id = m.staff_id;

    -- Q15
-- Create view vw_bike_catalog

CREATE VIEW vw_bike_catalog AS
SELECT 
    p.product_name,
    b.brand_name,
    c.category_name,
    p.model_year,
    p.list_price
FROM production.products p
JOIN production.brands b
    ON p.brand_id = b.brand_id
JOIN production.categories c
    ON p.category_id = c.category_id;

    -- Query the view

SELECT *
FROM vw_bike_catalog
WHERE list_price > 2000
ORDER BY list_price DESC;

-- Q16 BONUS
-- Create view vw_customer_orders

CREATE VIEW vw_customer_orders AS
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    o.order_id,
    o.order_date,
    s.store_name,
    o.order_status
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id
JOIN sales.stores s
    ON o.store_id = s.store_id;

    -- Query the view for customers from New York

SELECT 
    customer_name,
    order_id,
    order_date,
    store_name,
    order_status
FROM vw_customer_orders
WHERE city = 'New York'
ORDER BY order_date;