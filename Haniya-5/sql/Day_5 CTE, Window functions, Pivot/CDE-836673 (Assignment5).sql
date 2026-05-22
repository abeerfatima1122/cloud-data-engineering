
-- HOMEWORK: CLASS 5 - CTEs, PIVOT, EXPRESSIONS & WINDOW FUNCTIONS 

-- SECTION A: CASE Expressions

-- Q1: Show order_status as word instead of number
SELECT
    order_id,
    order_status,
    CASE
        WHEN order_status = 1 THEN 'Pending'
        WHEN order_status = 2 THEN 'Processing'
        WHEN order_status = 3 THEN 'Rejected'
        WHEN order_status = 4 THEN 'Completed'
        ELSE 'Unknown'
    END AS status_description
FROM sales.orders;


-- Q2: Categorize products by price
SELECT
    product_name,
    list_price,
    CASE
        WHEN list_price < 500 THEN 'Budget'
        WHEN list_price BETWEEN 500 AND 2000 THEN 'Standard'
        ELSE 'Premium'
    END AS price_category
FROM production.products;


-- Q3: Count completed vs non-completed orders for each store
SELECT
    store_id,
    COUNT(CASE WHEN order_status = 4 THEN 1 END) AS completed_count,
    COUNT(CASE WHEN order_status <> 4 THEN 1 END) AS not_completed_count
FROM sales.orders
GROUP BY store_id;


-- Q4: Create year_label column
SELECT
    product_name,
    model_year,
    CASE
        WHEN model_year = 2024 THEN 'New'
        WHEN model_year = 2023 THEN 'Recent'
        ELSE 'Older'
    END AS year_label
FROM production.products;


-- Q5: Show email and has_email column
SELECT
    email,
    CASE
        WHEN email IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS has_email
FROM sales.customers;



-- SECTION B: CTEs (Common Table Expressions)

-- Q6: High value products using CTE
WITH high_value_products AS (
    SELECT *
    FROM production.products
    WHERE list_price > 3000
)
SELECT *
FROM high_value_products;


-- Q7: Products costing more than average price
WITH avg_price AS (
    SELECT AVG(list_price) AS average_price
    FROM production.products
)
SELECT
    p.product_name,
    p.list_price
FROM production.products p
CROSS JOIN avg_price a
WHERE p.list_price > a.average_price;


-- Q8: Customers with more than 5 orders
WITH customer_order_counts AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM sales.orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    coc.total_orders
FROM customer_order_counts coc
JOIN sales.customers c
    ON c.customer_id = coc.customer_id
WHERE coc.total_orders > 5;


-- SECTION C: ROW_NUMBER() and RANK()

-- Q9: Number products by highest price
SELECT
    product_name,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS row_number
FROM production.products;


-- Q10: Rank products within each brand
SELECT
    brand_id,
    product_name,
    list_price,
    ROW_NUMBER() OVER (
        PARTITION BY brand_id
        ORDER BY list_price DESC
    ) AS rank_in_brand
FROM production.products;


-- Q11: Use RANK() on products ordered by price
SELECT
    product_name,
    list_price,
    RANK() OVER (ORDER BY list_price DESC) AS product_rank
FROM production.products;


-- SECTION D: Window Functions

-- Q12: Running total of daily orders
WITH daily_orders AS (
    SELECT
        order_date,
        COUNT(order_id) AS daily_order_count
    FROM sales.orders
    GROUP BY order_date
)
SELECT
    order_date,
    daily_order_count,
    SUM(daily_order_count) OVER (
        ORDER BY order_date
    ) AS running_total
FROM daily_orders;


-- Q13: Product price and average brand price
SELECT
    product_name,
    brand_id,
    list_price,
    AVG(list_price) OVER (
        PARTITION BY brand_id
    ) AS avg_brand_price
FROM production.products;


-- Q14: Running total of quantity sold per product
SELECT
    oi.product_id,
    o.order_date,
    oi.quantity,
    SUM(oi.quantity) OVER (
        PARTITION BY oi.product_id
        ORDER BY o.order_date
    ) AS cumulative_quantity
FROM sales.order_items oi
JOIN sales.orders o
    ON oi.order_id = o.order_id;

-- SECTION E: LAG, LEAD

-- Q15: Previous order date for each customer
SELECT
    customer_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_order_date
FROM sales.orders;


-- Q16: Days between consecutive orders
SELECT
    customer_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_order_date,
    DATEDIFF(
        DAY,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ),
        order_date
    ) AS days_between_orders
FROM sales.orders;


-- SECTION F: PIVOT

-- Q17: Pivot order status count for each store
SELECT *
FROM (
    SELECT
        store_id,
        order_status
    FROM sales.orders
) AS source_table
PIVOT (
    COUNT(order_status)
    FOR order_status IN ([1], [2], [3], [4])
) AS pivot_table;


-- SECTION G: Mixed Practice

-- Q18: Categorize customers by total spending
WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(
            oi.quantity * oi.list_price *
            (1 - oi.discount)
        ) AS total_spending
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    CASE
        WHEN cs.total_spending > 5000 THEN 'VIP'
        WHEN cs.total_spending BETWEEN 1000 AND 5000 THEN 'Regular'
        ELSE 'New'
    END AS tier
FROM customer_spending cs
JOIN sales.customers c
    ON c.customer_id = cs.customer_id;


-- Q19: Top 3 products per category with Gold/Silver/Bronze
WITH ranked_products AS (
    SELECT
        category_id,
        product_name,
        list_price,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY list_price DESC
        ) AS rank_num
    FROM production.products
)
SELECT
    category_id,
    product_name,
    list_price,
    rank_num,
    CASE
        WHEN rank_num = 1 THEN 'Gold'
        WHEN rank_num = 2 THEN 'Silver'
        WHEN rank_num = 3 THEN 'Bronze'
    END AS medal
FROM ranked_products
WHERE rank_num <= 3;


-- Q20: Monthly revenue and month-over-month growth
WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(
            oi.quantity * oi.list_price *
            (1 - oi.discount)
        ) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)
SELECT
    order_year,
    order_month,
    revenue,
    LAG(revenue) OVER (
        ORDER BY order_year, order_month
    ) AS previous_month_revenue,
    revenue -
    LAG(revenue) OVER (
        ORDER BY order_year, order_month
    ) AS growth
FROM monthly_revenue;


-- Q21: Product, price, rank in brand, top product label
WITH ranked_brand_products AS (
    SELECT
        product_name,
        brand_id,
        list_price,
        RANK() OVER (
            PARTITION BY brand_id
            ORDER BY list_price DESC
        ) AS brand_rank
    FROM production.products
)
SELECT
    product_name,
    list_price,
    brand_rank,
    CASE
        WHEN brand_rank = 1 THEN 'Top Product'
        ELSE 'Other'
    END AS product_label
FROM ranked_brand_products;


-- Q22: Pivot customer count by state and tier
WITH customer_tiers AS (
    SELECT
        c.state,
        CASE
            WHEN SUM(
                oi.quantity * oi.list_price *
                (1 - oi.discount)
            ) > 5000 THEN 'VIP'
            WHEN SUM(
                oi.quantity * oi.list_price *
                (1 - oi.discount)
            ) BETWEEN 1000 AND 5000 THEN 'Regular'
            ELSE 'New'
        END AS tier
    FROM sales.customers c
    JOIN sales.orders o
        ON c.customer_id = o.customer_id
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.state
)
SELECT *
FROM customer_tiers
PIVOT (
    COUNT(tier)
    FOR tier IN ([VIP], [Regular], [New])
) AS pivot_table;