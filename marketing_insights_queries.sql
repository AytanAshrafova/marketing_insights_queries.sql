MARKETING INSIGHTS FOR E-COMMERCE - postgresql queries
Bu skript Marketing Insights for E-Commerce layihəsi üçün istifadə olunan bütün SQL sorğularını ehtiva edir.
Sorğular bir neçə kateqoriyaya bölünmüşdür:
1. Müştəri Analizi
2. Satış Analizi
3. Məhsul və Kateqoriya Analizi
4. Endirim və Marketinq Xərcləri Analizi
5. RFM və LTV Analizi
6. Cohort və Next Purchase Analizi
7. Bundle və Market Basket Analizi
8. Advanced Analytics (Repeat Rate, Churn, TOP Products, Rank)
---------------------------------------
1. Chicago şəhərində olan müştərilər
------------------------------------
   SELECT * FROM public.customerdata
WHERE Location = 'Chicago';

---------------------------------------
2. Endirim istifadə olunan sifarişlər
----------------------------------------
Coupon istifadə olunan bütün sifarişləri tapır
SELECT * FROM public.online_sales
WHERE Coupon_Status = 'Used';

---------------------------------------

3. Ümumi sifariş sayı
----------------------------------
-- Bütün sifarişlərin sayını hesablayır
SELECT COUNT(Transaction_ID) AS Total_Orders
FROM public.online_sales; 

------------------------------------
4. Ümumi müştəri sayı                                      
-------------------------
 Unikal müştərilərin sayını hesablayır
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM public.online_sales;  

---------------------------------
5. Hər category üzrə satış sayı
----------------------------------

Məhsul kateqoriyaları üzrə sifarişlərin sayını hesablayır
SELECT Product_Category, COUNT(Transaction_ID) AS Total_Orders
FROM public.online_sales
GROUP BY Product_Category
ORDER BY Total_Orders DESC;

-----------------------------------------------------------
6. Hər məhsul üzrə satılan Quantity
----------------------------------------------------------
-- Hər məhsul üzrə ümumi satılan miqdarı hesablayır
SELECT Product_Description, SUM(Quantity) AS Total_Quantity
FROM public.online_sales
GROUP BY Product_Description
ORDER BY Total_Quantity DESC;

-------------------------------------------------------
 7. Hər müştərinin neçə dəfə alış etdiyi (Frequency)
-------------------------------------------------------
-- Hər müştərinin sifariş sayını hesablayır
SELECT CustomerID, COUNT(Transaction_ID) AS Frequency
FROM public.online_sales
GROUP BY CustomerID
ORDER BY Frequency DESC;

----------------------------------------------------  
8. Hər müştərinin xərclədiyi ümumi məbləğ (Revenue)
-----------------------------------------------------
-- Hər müştərinin toplam xərclədiyi məbləği hesablayır
SELECT 
    CustomerID,
    SUM(Quantity * Avg_Price) AS Revenue
FROM public.online_sales
GROUP BY CustomerID
ORDER BY Revenue DESC;

---------------------------------------------------------------
 9. Aylara görə satış sayı
---------------------------------------------------
-- Hər ay üçün ümumi sifariş sayını hesablayır
SELECT 
    DATE_TRUNC('month', Transaction_Date) AS MONTH,
    COUNT(Transaction_ID) AS Total_Orders
FROM online_sales
GROUP BY MONTH
ORDER BY MONTH;
--------------------------------------------
10. Aylara görə revenue
-- ==================================================================
-- Hər ay üçün ümumi gəliri (Revenue) hesablayır
SELECT 
    DATE_TRUNC('month', Transaction_Date) AS MONTH,
    SUM(Quantity * Avg_Price) AS Revenue
FROM online_sales
GROUP BY MONTH
ORDER BY MONTH;
---------------------------------------------------------
 11. Hər LOCATION üzrə müştəri sayı
------------------------------------------------
-- Hər şəhər/location üzrə unikal müştəri sayını hesablayır
SELECT LOCATION, COUNT(CustomerID) AS Total_Customers
FROM customerdata
GROUP BY LOCATION
ORDER BY Total_Customers DESC;


---------------------------------------------------------
12. Marketing spend – aylıq ümumi
----------------------------------------------
-- Hər ay üçün offline və online marketing xərclərinin cəmini hesablayır
SELECT 
    DATE_TRUNC('month', Date) AS MONTH,
    SUM(Offline_Spend + Online_Spend) AS Total_Marketing_Spend
FROM marketing_spend
GROUP BY MONTH
ORDER BY MONTH;
--------------------------------------------
13. GST ilə JOIN edərək kateqoriyaya görə vergi faizi
---------------------------------------------------
-- Hər məhsul kateqoriyası üçün GST faizini göstərir
SELECT 
    o.Product_Category,
    t.GST
FROM online_sales o
JOIN gstdetails t
ON o.Product_Category = t.Product_Category
GROUP BY o.Product_Category, t.GST;


---------------------------------------------------
-- 14. Invoice VALUE hesablayan QUERY
-----------------------------------------------
-- Hər tranzaksiya üçün Invoice Value (ümumi faktura məbləği) hesablayır
-- Formula: ((Quantity * Avg_Price) * (1 - Discount_pct/100) * (1 + GST/100)) + Delivery_Charges
SELECT 
    o.Transaction_ID,
    o.CustomerID,
    o.Product_Category,
    o.Quantity,
    o.Avg_Price,
    d.Discount_pct,
    t.GST,
    o.Delivery_Charges,
    
    (
      (o.Quantity * o.Avg_Price)
      * (1 - COALESCE(d.Discount_pct,0)/100)
      * (1 + COALESCE(t.GST,0)/100)
      + o.Delivery_Charges
    ) AS Invoice_Value

FROM online_sales o

LEFT JOIN discount_coupon d
ON DATE_TRUNC('month', o.Transaction_Date) = TO_DATE(d.Month, 'Mon')
AND o.Product_Category = d.Product_Category

LEFT JOIN gstdetails t
ON o.Product_Category = t.Product_Category
----------------------------------------------------------------------

15. RFM Analysis (Recency, Frequency, Monetary)
---------------------------------------------------------
-- Hər müştəri üçün Recency, Frequency və Monetary dəyərlərini hesablayır
SELECT 
    CustomerID,
    MAX(Transaction_Date) AS Last_Purchase_Date,
    COUNT(Transaction_ID) AS Frequency,
    SUM(Quantity * Avg_Price) AS Monetary
FROM online_sales
GROUP BY CustomerID;


-------------------------------------------------
-- 16. Cohort Analysis – FIRST Purchase MONTH
-----------------------------------------------
-- Müştərinin ilk alış etdiyi ayı tapır və həmin cohort üzrə hər ay aktiv müştəri sayını hesablayır
WITH first_purchase AS (
    SELECT 
        CustomerID,
        MIN(DATE_TRUNC('month', Transaction_Date)) AS Cohort_Month
    FROM online_sales
    GROUP BY CustomerID
)
SELECT 
    f.Cohort_Month,
    DATE_TRUNC('month', o.Transaction_Date) AS Order_Month,
    COUNT(DISTINCT o.CustomerID) AS Active_Customers
FROM online_sales o
JOIN first_purchase f
ON o.CustomerID = f.CustomerID
GROUP BY f.Cohort_Month, Order_Month
ORDER BY f.Cohort_Month, Order_Month;


-------------------------------------------------------
-- 17. Customer Lifetime VALUE (LTV) əsasında qruplama
-----------------------------------------------------------
-- Müştəriləri gəlirlərinə görə Low, Medium və High Value qruplarına ayırır
WITH customer_revenue AS (
    SELECT 
        CustomerID,
        SUM(Quantity * Avg_Price) AS Total_Revenue
    FROM online_sales
    GROUP BY CustomerID
)
SELECT *,
CASE 
    WHEN Total_Revenue > 3000 THEN 'High Value'
    WHEN Total_Revenue BETWEEN 1500 AND 3000 THEN 'Medium Value'
    ELSE 'Low Value'
END AS Customer_Level
FROM customer_revenue
ORDER BY Total_Revenue DESC;


----------------------------------------------
-- 18. NEXT Purchase DAY – pattern çıxarma
----------------------------------------------
-- Hər müştərinin ortalama alış intervalını hesablayır
WITH purchase_diff AS (
    SELECT
        CustomerID,
        Transaction_Date,
        Transaction_Date - LAG(Transaction_Date) OVER(PARTITION BY CustomerID ORDER BY Transaction_Date) AS Days_Between
    FROM online_sales
)
SELECT
    CustomerID,
    AVG(Days_Between) AS Avg_Days_Between_Purchase
FROM purchase_diff
WHERE Days_Between IS NOT NULL
GROUP BY CustomerID
ORDER BY CustomerID;


--------------------------------------------------------------
-- 19. Bundle Analysis (Market Basket – birlikdə alınan məhsullar)
-----------------------------------------------------------------
-- Hansı məhsulların birlikdə alındığını göstərir
SELECT 
    a.Product_Description AS Product_1,
    b.Product_Description AS Product_2,
    COUNT(*) AS Together_Count
FROM online_sales a
JOIN online_sales b
ON a.Transaction_ID = b.Transaction_ID
AND a.Product_Description <> b.Product_Description
GROUP BY Product_1, Product_2
ORDER BY Together_Count DESC;


------------------------------------------------
-- 20. Revenue vs Marketing Spend (impact analysis)
--------------------------------------------------------
-- Hər ay üçün revenue və marketing xərclərini müqayisə edir
WITH revenue AS (
  SELECT 
     DATE_TRUNC('month', Transaction_Date) AS MONTH,
     SUM(Quantity * Avg_Price) AS Revenue
  FROM online_sales
  GROUP BY MONTH
),
marketing AS (
  SELECT
     DATE_TRUNC('month', Date) AS MONTH,
     SUM(Offline_Spend + Online_Spend) AS Marketing
  FROM marketing_spend
  GROUP BY MONTH
)
SELECT
    r.Month,
    r.Revenue,
    m.Marketing,
    ROUND((m.Marketing / r.Revenue)*100,2) AS Marketing_Percentage
FROM revenue r
JOIN marketing m
ON r.Month = m.Month;


-------------------------------
-- 21. Hər gender üzrə revenue
----------------------------------
SELECT c.Gender,  SUM(o.Quantity * o.Avg_Price) AS Revenue
FROM online_sales o
JOIN customerdata c
ON o.CustomerID = c.CustomerID
GROUP BY c.Gender;


--------------------------------------------
-- 22. Hər tenure GROUP üzrə müştəri sayı
-------------------------------------------
-- Müştəriləri tenure aylarına görə qruplaşdırır
SELECT
    CASE 
        WHEN Tenure_Months <= 12 THEN '0-12 Months'
        WHEN Tenure_Months <= 24 THEN '12-24 Months'
        ELSE '24+ Months'
    END AS Tenure_Group,
    COUNT(CustomerID) AS Total_Customers
FROM customerdata
GROUP BY Tenure_Group;
-------------------------------------------------------
-- 23. Hər LOCATION üzrə ortalama purchase frequency
----------------------------------------------------------
WITH freq AS (
    SELECT CustomerID, COUNT(Transaction_ID) AS Frequency
    FROM online_sales
    GROUP BY CustomerID
)
SELECT c.Location, AVG(f.Frequency) AS Avg_Frequency
FROM freq f
JOIN customerdata c
ON f.CustomerID = c.CustomerID
GROUP BY c.Location;


---------------------------------------------------------
-- 24. Hər product_category üzrə avg invoice VALUE
---------------------------------------------------------
WITH invoice AS (
    SELECT 
        o.Transaction_ID,
        o.Product_Category,
        (o.Quantity * o.Avg_Price) AS Invoice_Value
    FROM online_sales o
)
SELECT Product_Category, AVG(Invoice_Value) AS Avg_Invoice
FROM invoice
GROUP BY Product_Category;


-- -----------------------------------------------
-- 25. Top 5 məhsul ən çox gəlir gətirən
-------------------------------------------
SELECT 
    Product_Description,
    SUM(Quantity * Avg_Price) AS Revenue
FROM online_sales
GROUP BY Product_Description
ORDER BY Revenue DESC
LIMIT 5;


----------------------------------------------------------
-- 26. Hər MONTH üzrə ən çox satılan product category
-- -------------------------------------------------------
SELECT 
    DATE_TRUNC('month', Transaction_Date) AS MONTH,
    Product_Category,
    SUM(Quantity) AS Total_Quantity
FROM online_sales
GROUP BY MONTH, Product_Category
ORDER BY MONTH, Total_Quantity DESC;


-----------------------------------------------------------------
-- 27. Hər ay və product_category üzrə endirimdən gələn revenue
--------------------------------------------------------------
SELECT 
    DATE_TRUNC('month', o.Transaction_Date) AS MONTH,
    o.Product_Category,
    SUM(o.Quantity * o.Avg_Price * (COALESCE(d.Discount_pct,0)/100)) AS Discount_Amount
FROM online_sales o
LEFT JOIN discount_coupon d
ON o.Product_Category = d.Product_Category
AND TO_CHAR(o.Transaction_Date, 'Mon') = d.Month
GROUP BY DATE_TRUNC('month', o.Transaction_Date), o.Product_Category
ORDER BY DATE_TRUNC('month', o.Transaction_Date);


-------------------------------------------------------
-- 28. Repeat Rate (təkrar alış edən müştərilər)
-- ---------------------------------------------------
WITH customer_freq AS (
    SELECT CustomerID, COUNT(Transaction_ID) AS Frequency
    FROM online_sales
    GROUP BY CustomerID
)
SELECT 
    ROUND(SUM(CASE WHEN Frequency > 1 THEN 1 ELSE 0 END)::DECIMAL / COUNT(*) * 100, 2) AS Repeat_Rate
FROM customer_freq;


-- ------------------------------------------------
-- 29. Churn Rate – 1 il ərzində alış etməyənlər
-- --------------------------------------------------
WITH last_purchase AS (
    SELECT CustomerID, MAX(Transaction_Date) AS Last_Purchase
    FROM online_sales
    GROUP BY CustomerID
)
SELECT 
    ROUND(SUM(CASE WHEN Last_Purchase < '2019-12-31' THEN 1 ELSE 0 END)::DECIMAL / COUNT(*) * 100,2) AS Churn_Rate
FROM last_purchase;


------------------------------------------------------------
-- 30. RFM segmentation ilə Premium / Gold / Silver / Standard
---------------------------------------------------------
WITH rfm AS (
    SELECT 
        CustomerID,
        MAX(Transaction_Date) AS Recency,
        COUNT(Transaction_ID) AS Frequency,
        SUM(Quantity * Avg_Price) AS Monetary
    FROM online_sales
    GROUP BY CustomerID
)
SELECT *,
CASE 
    WHEN Monetary > 3000 THEN 'Premium'
    WHEN Monetary BETWEEN 1500 AND 3000 THEN 'Gold'
    WHEN Monetary BETWEEN 500 AND 1500 THEN 'Silver'
    ELSE 'Standard'
END AS Segment
FROM rfm;


-- ----------------------------------------------------------
-- 31. Müştərinin əvvəlki və sonrakı alış tarixini tapmaq
-------------------------------------------------------------
SELECT
    CustomerID,
    Transaction_ID,
    Transaction_Date,
    LAG(Transaction_Date) OVER (PARTITION BY CustomerID ORDER BY Transaction_Date) AS prev_purchase_date,
    LEAD(Transaction_Date) OVER (PARTITION BY CustomerID ORDER BY Transaction_Date) AS next_purchase_date,
    Quantity,
    Avg_Price,
    Quantity * Avg_Price AS purchase_amount
FROM Online_Sales
ORDER BY CustomerID, Transaction_Date;


-- -----------------------------------------------------
-- 32. Müştəriləri ən çox xərcləyənlərə görə sıralamaq
-- -------------------------------------------------------
SELECT
    CustomerID,
    SUM(Quantity * Avg_Price) AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM(Quantity * Avg_Price) DESC) AS revenue_rank
FROM Online_Sales
GROUP BY CustomerID
ORDER BY revenue_rank;


-- -----------------------------------------------
-- 33. LAST_VALUE ilə son alış məbləğini tapmaq
---------------------------------------------------
SELECT
    CustomerID,
    Transaction_ID,
    Transaction_Date,
    LAST_VALUE(Quantity * Avg_Price) OVER (
        PARTITION BY CustomerID
        ORDER BY Transaction_Date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_purchase_amount
FROM Online_Sales
ORDER BY CustomerID, Transaction_Date;
