
-- HOMEWORK: CLASS 4 - MODIFYING DATA, DDL, DATA TYPES & CONSTRAINTS

-- SECTION A: DATA TYPES & CONSTRAINTS

-- Q1: What data type would you use for a product's weight (e.g., 2.5 kg)?

-- Answer:
-- DECIMAL(5,2)
-- Example: 999.99


-- Q2: In the sales.stores table, the zip_code is VARCHAR(5). Why not use INT?

-- Answer:
-- ZIP codes may start with 0 and are not used for calculations,
-- so VARCHAR is better than INT.


-- Q3: Is TINYINT a good choice for order_status? Why not INT?

-- Answer:
-- Yes, TINYINT is a good choice because only small values (1-4)
-- are needed and it saves storage compared to INT.


-- Q4: What happens if rating = 0 is inserted when CHECK constraint is BETWEEN 1 AND 5?

-- Answer:
-- SQL Server will reject the insert and show a CHECK constraint error.


-- Q5: Why UNIQUE on email but not on phone?

-- Answer:
-- Each staff member should have a unique email,
-- but phone numbers may be shared or duplicated.


-- SECTION B: DDL (CREATE, ALTER, DROP)

-- Q6: Create sales.loyalty_programs table

CREATE TABLE sales.loyalty_programs (
    program_id INT IDENTITY(1,1) PRIMARY KEY,

    program_name VARCHAR(100) NOT NULL UNIQUE,

    discount_rate DECIMAL(3,2) NOT NULL
        DEFAULT 0.05
        CHECK (discount_rate BETWEEN 0.00 AND 0.50),

    start_date DATE NOT NULL DEFAULT GETDATE(),

    end_date DATE NULL
);


-- Q7: Add loyalty_program_id column to sales.customers

ALTER TABLE sales.customers
ADD loyalty_program_id INT NULL;


-- Q8: Add FOREIGN KEY constraint

ALTER TABLE sales.customers
ADD CONSTRAINT FK_customers_loyalty_program
FOREIGN KEY (loyalty_program_id)
REFERENCES sales.loyalty_programs(program_id);


-- Q9: Change zip_code from VARCHAR(5) to VARCHAR(10)

ALTER TABLE sales.customers
ALTER COLUMN zip_code VARCHAR(10);


-- Q10: Add birth_date column then drop it

ALTER TABLE sales.customers
ADD birth_date DATE NULL;

ALTER TABLE sales.customers
DROP COLUMN birth_date;


-- Q11: Create production.product_reviews table

CREATE TABLE production.product_reviews (

    review_id INT IDENTITY(1,1) PRIMARY KEY,

    product_id INT NOT NULL,

    customer_id INT NOT NULL,

    rating TINYINT NOT NULL
        CHECK (rating BETWEEN 1 AND 5),

    review_text VARCHAR(1000),

    review_date DATE DEFAULT GETDATE(),

    CONSTRAINT FK_reviews_products
        FOREIGN KEY (product_id)
        REFERENCES production.products(product_id),

    CONSTRAINT FK_reviews_customers
        FOREIGN KEY (customer_id)
        REFERENCES sales.customers(customer_id)
);


-- SECTION C: INSERT STATEMENTS

-- Q12: Insert new brand 'Santa Cruz'

INSERT INTO production.brands (brand_name)
VALUES ('Santa Cruz');


-- Q13: Insert 3 categories

INSERT INTO production.categories (category_name)
VALUES
('Mountain'),
('Road'),
('Hybrid');


-- Q14: Insert new product

INSERT INTO production.products
(
    product_name,
    brand_id,
    category_id,
    model_year,
    list_price
)
VALUES
(
    'Santa Cruz Bronson',

    (SELECT brand_id
     FROM production.brands
     WHERE brand_name = 'Santa Cruz'),

    (SELECT category_id
     FROM production.categories
     WHERE category_name = 'Mountain'),

    2025,
    4299.99
);


-- Q15: Copy CA customers into backup table

SELECT *
INTO sales.ca_customers_backup
FROM sales.customers
WHERE 1 = 0;

INSERT INTO sales.ca_customers_backup
SELECT *
FROM sales.customers
WHERE state = 'CA';


-- SECTION D: UPDATE STATEMENTS

-- Q16: Update phone number

UPDATE sales.customers
SET phone = '(555) 123-4567'
WHERE customer_id = 10;


-- Q17: Increase Road category prices by 8%

UPDATE production.products
SET list_price = list_price * 1.08
WHERE category_id =
(
    SELECT category_id
    FROM production.categories
    WHERE category_name = 'Road'
);


-- Q18: Set shipped_date = order_date + 3 days

UPDATE sales.orders
SET shipped_date = DATEADD(DAY, 3, order_date)
WHERE order_status = 4
AND shipped_date IS NULL;


-- Q19: Set manager_id = 5 for staffs in store_id = 1

UPDATE sales.staffs
SET manager_id = 5
WHERE store_id = 1
AND staff_id <> 5;


-- Q20: Update discount

UPDATE sales.order_items
SET discount = 0.15
WHERE order_id = 100
AND item_id = 2;


-- SECTION E: DELETE STATEMENTS

-- Q21: Delete brand 'Santa Cruz'

DELETE FROM production.brands
WHERE brand_name = 'Santa Cruz';


-- Q22: Delete order_items with quantity = 0

DELETE FROM sales.order_items
WHERE quantity = 0;


-- Q23: Delete customers with no orders

DELETE FROM sales.customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);


-- Q24: Delete expensive old products

DELETE FROM production.products
WHERE list_price > 10000
AND model_year < 2020;


-- Q25: Delete loyalty_programs table

DROP TABLE sales.loyalty_programs;

-- SECTION F: COMBINED & CHALLENGE QUESTIONS

-- Q26: Transaction example

BEGIN TRY

    BEGIN TRANSACTION;

    -- Create new store

    INSERT INTO sales.stores
    (
        store_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code
    )
    VALUES
    (
        'Downtown LA',
        '(213) 555-1111',
        'downtownla@bikestore.com',
        'Main Street',
        'Los Angeles',
        'CA',
        '90001'
    );

    DECLARE @store_id INT;

    SET @store_id = SCOPE_IDENTITY();

    -- Add 3 staff members

    INSERT INTO sales.staffs
    (
        first_name,
        last_name,
        email,
        phone,
        active,
        store_id,
        manager_id
    )
    VALUES
    ('John', 'Smith', 'john@bike.com', '1111111111', 1, @store_id, NULL),
    ('Sara', 'Lee', 'sara@bike.com', '2222222222', 1, @store_id, NULL),
    ('Mike', 'Brown', 'mike@bike.com', '3333333333', 1, @store_id, NULL);

    -- Insert stock

    INSERT INTO production.stocks
    (
        store_id,
        product_id,
        quantity
    )
    VALUES
    (
        @store_id,
        1,
        100
    );

    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    ROLLBACK TRANSACTION;

    PRINT 'Transaction Failed';

END CATCH;


-- Q27: Add tax_amount column and update values

ALTER TABLE sales.order_items
ADD tax_amount DECIMAL(8,2) DEFAULT 0.00;

UPDATE sales.order_items
SET tax_amount =
(list_price * quantity * discount * 0.08);


-- Q28: Delete duplicate customer emails

WITH DuplicateEmails AS
(
    SELECT
        customer_id,
        email,
        ROW_NUMBER() OVER
        (
            PARTITION BY email
            ORDER BY customer_id
        ) AS rn
    FROM sales.customers
)

DELETE FROM DuplicateEmails
WHERE rn > 1;


-- Q29: Archive orders from 2020 or older

SELECT *
INTO sales.orders_archive
FROM sales.orders
WHERE 1 = 0;

INSERT INTO sales.orders_archive
SELECT *
FROM sales.orders
WHERE YEAR(order_date) <= 2020;

DELETE FROM sales.orders
WHERE YEAR(order_date) <= 2020;


-- Q30: Add CHECK constraint to production.products

ALTER TABLE production.products
ADD CONSTRAINT CHK_products_price_year
CHECK
(
    list_price >= 0
    AND model_year BETWEEN 1900 AND YEAR(GETDATE()) + 1
);