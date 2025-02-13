-- Creating table in DuckDB using CSV
CREATE TABLE transactions AS 
SELECT
	*
FROM
	read_csv_auto('assessment_dataset(in).csv')

	
-- Time range of transactions
SELECT 
    MIN(STRPTIME(TransactionDate, '%m/%d/%Y %H:%M')) AS first_transaction_time,
    MAX(STRPTIME(TransactionDate, '%m/%d/%Y %H:%M')) AS last_transaction_time
FROM transactions;


-- Check for missing or null values across columns
SELECT 
    SUM(CASE WHEN TransactionID IS NULL THEN 1 ELSE 0 END) AS missing_TransactionID,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS missing_CustomerID,
    SUM(CASE WHEN TransactionDate IS NULL THEN 1 ELSE 0 END) AS missing_TransactionDate,
    SUM(CASE WHEN TransactionAmount IS NULL THEN 1 ELSE 0 END) AS missing_TransactionAmount,
    SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS missing_PaymentMethod,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS missing_Quantity,
    SUM(CASE WHEN DiscountPercent IS NULL THEN 1 ELSE 0 END) AS missing_DiscountPercent,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS missing_City,
    SUM(CASE WHEN StoreType IS NULL THEN 1 ELSE 0 END) AS missing_StoreType,
    SUM(CASE WHEN CustomerAge IS NULL THEN 1 ELSE 0 END) AS missing_CustomerAge,
    SUM(CASE WHEN CustomerGender IS NULL THEN 1 ELSE 0 END) AS missing_CustomerGender,
    SUM(CASE WHEN LoyaltyPoints IS NULL THEN 1 ELSE 0 END) AS missing_LoyaltyPoints,
    SUM(CASE WHEN ProductName IS NULL THEN 1 ELSE 0 END) AS missing_ProductName,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS missing_Region,
    SUM(CASE WHEN Returned IS NULL THEN 1 ELSE 0 END) AS missing_Returned,
    SUM(CASE WHEN FeedbackScore IS NULL THEN 1 ELSE 0 END) AS missing_FeedbackScore,
    SUM(CASE WHEN ShippingCost IS NULL THEN 1 ELSE 0 END) AS missing_ShippingCost,
    SUM(CASE WHEN DeliveryTimeDays IS NULL THEN 1 ELSE 0 END) AS missing_DeliveryTimeDays,
    SUM(CASE WHEN IsPromotional IS NULL THEN 1 ELSE 0 END) AS missing_IsPromotional
FROM transactions;


-- Sales metrics
SELECT 
    COUNT(*) AS num_transactions,
    ROUND(SUM(TransactionAmount),2) AS net_sales,
    ROUND(SUM(CASE WHEN TransactionAmount > 0 THEN TransactionAmount ELSE 0 END),2) AS gross_sales,
    ROUND(AVG(CASE WHEN TransactionAmount > 0 THEN TransactionAmount ELSE 0 END),2) AS avg_transaction_value,
FROM transactions;


-- Sales Breakdown by StoreType & Region
SELECT 
    StoreType, 
    Region, 
    COUNT(TransactionID) AS total_transactions, 
    ROUND(SUM(TransactionAmount),2) AS net_sales 
FROM transactions 
WHERE StoreType IS NOT NULL and Region IS NOT NULL
GROUP BY StoreType, Region 
ORDER BY net_sales DESC;


-- Top 10 Cities in terms of sales
SELECT 
    City, 
    ROUND(SUM(TransactionAmount),2) AS city_net_sales, 
    COUNT(TransactionID) AS total_transactions 
FROM transactions 
GROUP BY City 
ORDER BY city_net_sales DESC 
LIMIT 10;


-- CustomerGender distribution
SELECT 
    CustomerGender, 
    COUNT(*) AS num_customers
FROM transactions
GROUP BY CustomerGender;


-- Customer PaymentMethod distribution
SELECT 
    PaymentMethod, 
    COUNT(*) AS num_customers
FROM transactions
GROUP BY PaymentMethod;


-- Binned CustomerAge Distribution
SELECT 
    CASE 
        WHEN CustomerAge < 18 THEN 'Under 18'
        WHEN CustomerAge BETWEEN 18 AND 24 THEN '18-24'
        WHEN CustomerAge BETWEEN 25 AND 34 THEN '25-34'
        WHEN CustomerAge BETWEEN 35 AND 44 THEN '35-44'
        WHEN CustomerAge BETWEEN 45 AND 54 THEN '45-54'
        WHEN CustomerAge BETWEEN 55 AND 64 THEN '55-64'
        WHEN CustomerAge >= 65 THEN '65+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS num_customers
FROM transactions
GROUP BY age_group
ORDER BY age_group;


-- Shipping metrics
SELECT 
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY DeliveryTimeDays), 2) AS median_delivery_time,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY ShippingCost), 2) AS median_shipping_cost
FROM transactions;
