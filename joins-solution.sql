-- Tasks

-- 1. Get all customers and their addresses.
SELECT c.first_name, c.last_name, a.street, a.city, a.state, a.zip, a.address_type
FROM addresses a
JOIN customers c ON a.customer_id=c.id
ORDER BY c.last_name;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT o.id as order_id, li.quantity, p.description FROM line_items li
JOIN orders o ON li.order_id=o.id
JOIN products p ON li.product_id=p.id;

-- 3. Which warehouses have cheetos?
SELECT w.warehouse, wp.on_hand FROM warehouse_product wp
JOIN products p ON p.id=wp.product_id
JOIN warehouse w ON w.id=wp.warehouse_id
WHERE p.description = 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT w.warehouse, wp.on_hand FROM warehouse_product wp
JOIN products p ON p.id=wp.product_id
JOIN warehouse w ON w.id=wp.warehouse_id
WHERE p.description = 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT CONCAT(c.first_name, ' ', c.last_name) AS "name", COUNT(o.id) FROM addresses a
JOIN customers c ON c.id=a.customer_id
JOIN orders o ON o.address_id=a.id
GROUP BY "name" ORDER BY count;

-- 6. How many customers do we have?
SELECT COUNT(id) FROM customers;

-- 7. How many products do we carry?
SELECT COUNT(id) FROM products;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT SUM(wp.on_hand) AS "diet pepsi count" FROM warehouse_product wp
JOIN products p ON p.id=wp.product_id
WHERE p.description = 'diet pepsi';

-- Stretch

-- 9. How much was the total cost for each order?
SELECT o.id AS "order id", SUM(li.quantity * p.unit_price) AS "total cost"
FROM line_items li
JOIN orders o ON o.id=li.order_id
JOIN products p ON p.id=li.product_id
GROUP BY o.id ORDER BY "total cost";

-- 10. How much has each customer spent in total?
SELECT CONCAT(c.first_name, ' ', c.last_name) AS "name", 
SUM(li.quantity * p.unit_price) AS "total spent"
FROM line_items li
JOIN orders o ON o.id=li.order_id
JOIN products p ON p.id=li.product_id
RIGHT JOIN addresses a ON a.id=o.address_id
RIGHT JOIN customers c ON c.id=a.customer_id
GROUP BY "name" ORDER BY "total spent";

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT CONCAT(c.first_name, ' ', c.last_name) AS "name", 
COALESCE(SUM(li.quantity * p.unit_price), 0) AS "total spent"
FROM line_items li
JOIN orders o ON o.id=li.order_id
JOIN products p ON p.id=li.product_id
RIGHT JOIN addresses a ON a.id=o.address_id
RIGHT JOIN customers c ON c.id=a.customer_id
GROUP BY "name" ORDER BY "total spent" DESC;