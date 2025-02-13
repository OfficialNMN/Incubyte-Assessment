-- Detecting Outliers in Transaction Amount
SELECT 
	PERCENTILE_CONT(0) WITHIN GROUP (ORDER BY TransactionAmount) AS p0,
    PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY TransactionAmount) AS p5,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY TransactionAmount) AS p95,
    PERCENTILE_CONT(1) WITHIN GROUP (ORDER BY TransactionAmount) AS p100
FROM transactions

  
-- RFM Analysis for Customer Segmentation
WITH rfm AS (
    SELECT 
        CustomerID,
        DATEDIFF('day', MAX(STRPTIME(TransactionDate, '%m/%d/%Y %H:%M')), current_date) AS Recency, 
        COUNT(TransactionID) AS Frequency, 
        ROUND(SUM(TransactionAmount),2) AS Monetary
    FROM transactions
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    NTILE(5) OVER (ORDER BY Recency DESC) AS Recency_Score,
    NTILE(5) OVER (ORDER BY Frequency DESC) AS Frequency_Score,
    NTILE(5) OVER (ORDER BY Monetary DESC) AS Monetary_Score
FROM rfm
ORDER BY Recency_Score DESC, Frequency_Score DESC, Monetary_Score DESC;


-- Cohort analysis for Customer retention
WITH cohort_data AS (
    SELECT 
        CustomerID, 
        MIN(DATE_TRUNC('month', STRPTIME(TransactionDate, '%m/%d/%Y %H:%M'))) AS first_purchase_month, 
        DATE_TRUNC('month', STRPTIME(TransactionDate, '%m/%d/%Y %H:%M')) AS transaction_month
    FROM transactions
    GROUP BY CustomerID, transaction_month
)
SELECT 
    first_purchase_month, 
    transaction_month, 
    COUNT(DISTINCT CustomerID) AS active_customers
FROM cohort_data
GROUP BY first_purchase_month, transaction_month
ORDER BY first_purchase_month, transaction_month;
