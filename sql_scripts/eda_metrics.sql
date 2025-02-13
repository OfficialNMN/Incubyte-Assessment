-- Creating table in DuckDB using CSV
CREATE TABLE transactions AS 
SELECT
	*
FROM
	read_csv_auto('assessment_dataset(in).csv')

-- Date range of transactions
SELECT 
    MIN(TransactionDate) AS first_transaction,
    MAX(TransactionDate) AS last_transaction
FROM transactions;
  
-- Sales metrics
SELECT 
	  COUNT(*) AS total_transactions,
    ROUND(SUM(TransactionAmount),2) AS total_revenue, 
    ROUND(AVG(TransactionAmount),2) AS avg_transaction_value 
FROM transactions;

-- Sales breakdown by StoreType & Region:
SELECT 
    StoreType, 
    Region, 
    COUNT(TransactionID) AS total_transactions, 
    ROUND(SUM(TransactionAmount),2) AS total_revenue 
FROM transactions 
GROUP BY StoreType, Region 
ORDER BY total_revenue DESC;

