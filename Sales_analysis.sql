-- Joining the first and last name columns, and then creating categorized column using CASE for base salary
-- Sort data by full name 
-- View for income categorization

SELECT
    salesperson_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    region,
    base_salary,
	CASE 
		WHEN base_salary < 40000 THEN 'Low Income'
        WHEN base_salary BETWEEN 40000 AND 65000 THEN 'Average Income'
        ELSE 'Good Income'
    END AS income_range,
     hire_date

FROM salespersons
ORDER BY full_name Asc
Limit 200;

-- Finding the product categories that generate the highest profit margin
-- find profit as well
-- join orders table on order items table, join products table on order items table

SELECT
    p.category,
    SUM(oi.line_total) AS total_revenue,
    SUM(oi.quantity * p.unit_price) AS total_cost,
    SUM(oi.line_total - (oi.quantity * p.unit_price)) AS total_profit,
    ROUND(
        (SUM(oi.line_total - (oi.quantity * p.unit_price)) 
        / NULLIF(SUM(oi.line_total), 0)) * 100,
        2
    ) AS profit_margin_percent
FROM orderitems oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY profit_margin_percent DESC;

-- Which products are at risk of overstocking or stockouts based on how fast they sell?

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_units_sold,
    p.stock_quantity,
    ROUND(
        SUM(oi.quantity) / NULLIF(p.stock_quantity, 0),
        2
    ) AS sell_through_ratio,
    CASE
        WHEN SUM(oi.quantity) >= p.stock_quantity THEN 'Stockout Risk'
        WHEN SUM(oi.quantity) >= p.stock_quantity * 0.7 THEN 'Healthy Movement'
        ELSE 'Overstock Risk'
    END AS inventory_status
FROM orderitems oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.stock_quantity
ORDER BY sell_through_ratio DESC;


