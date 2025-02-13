-- Customer Loyalty Insights
SELECT 
    CustomerID, 
    SUM(LoyaltyPoints) AS total_points, 
    COUNT(TransactionID) AS num_purchases 
FROM transactions 
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID 
ORDER BY total_points DESC 
LIMIT 10;


-- Effectiveness of Discounts on Sales
WITH binned_data AS (
    SELECT 
        DiscountPercent, 
        COUNT(TransactionID) AS num_transactions, 
        SUM(TransactionAmount) AS net_sales,
        NTILE(10) OVER (ORDER BY DiscountPercent) AS discount_bin
    FROM transactions
    WHERE DiscountPercent > 0
    GROUP BY DiscountPercent
)
SELECT 
    discount_bin,
    MIN(DiscountPercent) AS min_discount,
    MAX(DiscountPercent) AS max_discount,
    SUM(num_transactions) AS total_transactions,
    ROUND(SUM(net_sales),2) AS net_sales
FROM binned_data
GROUP BY discount_bin
ORDER BY discount_bin;


-- Repeat vs New Customers
WITH customer_cte AS (
    SELECT CustomerID, 
           COUNT(TransactionID) AS transaction_count
    FROM transactions
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT 
    CASE 
        WHEN transaction_count > 1 THEN 'Repeat Customer' 
        ELSE 'New Customer' 
    END AS customer_type,
    COUNT(DISTINCT CustomerID) AS customer_count
FROM customer_cte
GROUP BY customer_type;


-- Promotional Sales Performance
SELECT 
    IsPromotional, 
    COUNT(TransactionID) AS num_transactions, 
    ROUND(SUM(TransactionAmount),2) AS net_sales 
FROM transactions 
GROUP BY IsPromotional;


-- Returns & Customer Feedback
SELECT 
    Returned, 
    ROUND(AVG(FeedbackScore),2) AS avg_feedback, 
    COUNT(TransactionID) AS num_returns 
FROM transactions 
GROUP BY Returned;


-- Correlation Between DeliveryTime & FeedbackScore
SELECT 
    DeliveryTimeDays, 
    ROUND(AVG(FeedbackScore),2) AS avg_feedback 
FROM transactions 
GROUP BY DeliveryTimeDays 
ORDER BY DeliveryTimeDays;
