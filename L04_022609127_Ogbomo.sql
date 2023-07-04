/*Name: Shawn Ogbomo
 Student# 022609127
 Date 02/18/2022
 Section DBS311NGG
 Instructor Riyadh Al-Essawi*/
-- Question 1     
-- Display cities that no warehouse is located in them. (use set operators to answer this question
SELECT city
FROM locations
WHERE location_id IN
      (SELECT location_id
       FROM locations
       minus
       SELECT location_id
       FROM warehouses)
ORDER BY city;
-- question 2
-- Display the category ID, category name, and the number of products in category 1, 2, and 5.
-- In your result, display first the number of products in category 5, then category 1 and then 2.
SELECT pc.category_id,
       pc.category_name,
       COUNT(*)
FROM product_categories pc
         LEFT OUTER JOIN
     products p
     ON pc.category_id = p.category_id
GROUP BY pc.category_id,
         pc.category_name
HAVING pc.category_id < 3
    OR pc.category_id = 5
ORDER BY COUNT(*) DESC;
-- question 3
SELECT product_id
FROM products
INTERSECT
SELECT product_id
FROM inventories
WHERE quantity < ANY (SELECT quantity
                      FROM inventories
                      INTERSECT
                      SELECT category_id
                      FROM products)
ORDER BY product_id;
-- question 4
-- We need a single report to display all warehouses and the state that they are located in and all states regardless of whether they have warehouses in them or not.
-- (Use set operators in you answer.)
SELECT w.warehouse_name,
       l.state
FROM warehouses w
         LEFT OUTER JOIN
     locations l
     ON w.location_id = l.location_id
UNION
SELECT to_char(NULL),
       state
FROM locations
WHERE location_id IN
      (SELECT location_id
       FROM locations
       minus
       SELECT location_id
       FROM warehouses);