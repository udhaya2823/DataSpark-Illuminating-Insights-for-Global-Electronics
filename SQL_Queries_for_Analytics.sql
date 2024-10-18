select * from customers;
select * from exchange_rates;
select * from products;
select * from sales;
select * from stores;

-- Queries for insights

-- 1. Overall female count
SELECT COUNT(Gender) AS Female_count 
FROM customers 
WHERE Gender = "Female";

-- 2. Overall male count
SELECT COUNT(Gender) AS Male_count 
FROM customers 
WHERE Gender = "Male";

-- 3. Count of customers by country
SELECT sd.Country, COUNT(DISTINCT c.CustomerKey) AS customer_count 
FROM sales c 
JOIN stores sd ON c.StoreKey = sd.StoreKey
GROUP BY sd.Country 
ORDER BY customer_count DESC;

-- 4. Overall count of customers
SELECT COUNT(DISTINCT s.CustomerKey) AS customer_count 
FROM sales s;

-- 5. Count of stores by country
SELECT Country, COUNT(StoreKey) 
FROM stores
GROUP BY Country 
ORDER BY COUNT(StoreKey) DESC;

-- 6. Store-wise sales
SELECT s.StoreKey, sd.Country, SUM(pd.Unit_Price_USD * s.Quantity) AS total_sales_amount 
FROM products pd
JOIN sales s ON pd.ProductKey = s.ProductKey 
JOIN stores sd ON s.StoreKey = sd.StoreKey 
GROUP BY s.StoreKey, sd.Country;

-- 7. Overall selling amount
SELECT SUM(pd.Unit_Price_USD * sd.Quantity) AS total_sales_amount 
FROM productss pd
JOIN sales sd ON pd.ProductKey = sd.ProductKey;

-- 8. Brand count
SELECT Brand, COUNT(Brand) AS brand_count 
FROM products 
GROUP BY Brand;

-- 9. CP and SP difference and profit
SELECT Unit_price_USD, Unit_Cost_USD, 
       ROUND((Unit_price_USD - Unit_Cost_USD), 2) AS diff,
       ROUND(((Unit_price_USD - Unit_Cost_USD) / Unit_Cost_USD) * 100, 2) AS profit_percent
FROM products;

-- 10. Brand-wise selling amount
SELECT Brand, ROUND(SUM(pd.Unit_price_USD * sd.Quantity), 2) AS sales_amount
FROM products pd 
JOIN sales sd ON pd.ProductKey = sd.ProductKey 
GROUP BY Brand;

-- 11. Subcategory-wise selling amount
SELECT Subcategory, COUNT(Subcategory) 
FROM products 
GROUP BY Subcategory;

-- Subcategory-wise total sales
SELECT Subcategory, ROUND(SUM(pd.Unit_price_USD * sd.Quantity), 2) AS TOTAL_SALES_AMOUNT
FROM products pd 
JOIN sales sd ON pd.ProductKey = sd.ProductKey
GROUP BY Subcategory 
ORDER BY TOTAL_SALES_AMOUNT DESC;

-- 12. Country overall sales
SELECT s.Country, SUM(pd.Unit_price_USD * sd.Quantity) AS total_sales 
FROM products pd
JOIN sales sd ON pd.ProductKey = sd.ProductKey 
JOIN stores s ON sd.StoreKey = s.StoreKey 
GROUP BY s.Country;

-- 13. Year-wise brand sales
SELECT YEAR(Order_Date), pd.Brand, 
       ROUND(SUM(pd.Unit_price_USD * sd.Quantity), 2) AS year_sales 
FROM sales sd
JOIN products pd ON sd.ProductKey = pd.ProductKey 
GROUP BY YEAR(Order_Date), pd.Brand;

-- 14. Month-wise sales
SELECT MONTH(Order_Date), SUM(pd.Unit_price_USD * sd.Quantity) AS sp_month 
FROM sales sd 
JOIN products pd ON sd.ProductKey = pd.ProductKey 
GROUP BY MONTH(Order_Date);

-- 15. Month and year-wise sales with quantity
SELECT MONTH(Order_Date), YEAR(Order_Date), pd.Brand, 
       SUM(pd.Unit_price_USD * sd.Quantity) AS sp_month 
FROM sales sd 
JOIN products pd ON sd.ProductKey = pd.ProductKey 
GROUP BY MONTH(Order_Date), YEAR(Order_Date), pd.Brand;

-- 16. Year-wise sales
SELECT YEAR(Order_Date), SUM(pd.Unit_price_USD * sd.Quantity) AS sp_month 
FROM sales sd 
JOIN products pd ON sd.ProductKey = pd.ProductKey 
GROUP BY YEAR(Order_Date);

-- 17. Comparing current month and previous month sales
SELECT YEAR(Order_Date), MONTH(Order_Date), 
       ROUND(SUM(pd.Unit_Price_USD * sd.Quantity), 2) AS sales, 
       LAG(ROUND(SUM(pd.Unit_Price_USD * sd.Quantity), 2)) 
       OVER (ORDER BY YEAR(Order_Date), MONTH(Order_Date)) AS Previous_Month_Sales
FROM sales sd 
JOIN products pd ON sd.ProductKey = pd.ProductKey 
GROUP BY YEAR(Order_Date), MONTH(Order_Date);

-- 18. Year-wise profit
SELECT YEAR(Order_Date) AS Year,
       (SUM(pd.Unit_Price_USD * sd.Quantity) - SUM(pd.Unit_Cost_USD * sd.Quantity)) AS sales, 
       LAG(SUM(pd.Unit_Price_USD * sd.Quantity) - SUM(pd.Unit_Cost_USD * sd.Quantity)) 
       OVER (ORDER BY YEAR(Order_Date)) AS Previous_year_Sales,
       ROUND(((SUM(pd.Unit_Price_USD * sd.Quantity) - SUM(pd.Unit_Cost_USD * sd.Quantity)) -
       LAG(SUM(pd.Unit_Price_USD * sd.Quantity) - SUM(pd.Unit_Cost_USD * sd.Quantity)) 
       OVER (ORDER BY YEAR(Order_Date))) / LAG(SUM(pd.Unit_Price_USD * sd.Quantity) - SUM(pd.Unit_Cost_USD * sd.Quantity)) 
       OVER (ORDER BY YEAR(Order_Date)) * 100, 2) AS profit_percent
FROM sales sd 
JOIN products pd ON sd.ProductKey = pd.ProductKey 
GROUP BY YEAR(Order_Date);
