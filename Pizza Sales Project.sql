-- Pizza Sales SQL Project

-- Całkowita liczba złożonych zamówień

SELECT COUNT(order_id) AS total_orders
FROM orders;



-- Całkowity przychód ze sprzedaży pizzy

SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;



-- Najdroższa pizza

SELECT pizza_id, price
FROM pizzas
ORDER BY price DESC
LIMIT 1;



-- Najczęściej zamawainy rozmiar pizzy

SELECT size, COUNT(*) AS size_count
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY size_count DESC
LIMIT 1;



-- 5 Najczęściej zamawianych rodzajów pizzy oraz ich ilość

SELECT pt.name AS pizza_type, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;



-- Ilość zamówinej pizzy według kategorii

SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;



-- Ilość zamówionej pizzy według oddzielnych kategorii

SELECT pt.category, p.pizza_id, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, p.pizza_id
ORDER BY pt.category, total_quantity DESC;



-- Całkowity udział każdego rodzaju pizzy w całkowitych przychodach
-- 1.Całkowity przychód dla każdego rodzaju pizzy

WITH pizza_revenue AS (
    SELECT pt.name AS pizza_type, SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
),

-- 2.Całkowity dochód

total_revenue AS (
    SELECT SUM(total_revenue) AS overall_revenue
    FROM pizza_revenue
)

-- 3.KProcentowy udział każdego rodzaju pizzy

SELECT pr.pizza_type, pr.total_revenue,
       (pr.total_revenue / tr.overall_revenue) * 100 AS percentage_contribution
FROM pizza_revenue pr, total_revenue tr
ORDER BY percentage_contribution DESC;
