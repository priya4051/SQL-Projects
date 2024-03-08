#how recently a customer has made a purchase (Recency),
#how often they make purchases (Frequency),
#how much money they spend (Monetary value).
#With the RFM scores available, you can classify customers into segments
WITH 
    Recency AS (
        SELECT CustomerID, DATEDIFF(CURRENT_DATE, MAX(PurchaseDate)) AS Recency
        FROM rfm.rfm_data
        GROUP BY CustomerID
    ),
    Frequency AS (
        SELECT CustomerID, COUNT(*) AS Frequency
        FROM rfm.rfm_data
        GROUP BY CustomerID
    ),
    Monetary AS (
        SELECT CustomerID, SUM(TransactionAmount) AS Monetary
        FROM rfm.rfm_data
        GROUP BY CustomerID
    ),
    Combinedrfm AS (
        SELECT R.CustomerID, R.Recency, F.Frequency, M.Monetary
        FROM Recency R
        JOIN Frequency F ON R.CustomerID = F.CustomerID
        JOIN Monetary M ON R.CustomerID = M.CustomerID
    )
SELECT CustomerID,
       CASE
           WHEN Recency <= 30 THEN 'High'
           WHEN Recency BETWEEN 31 AND 60 THEN 'Medium'
           ELSE 'Low'
       END AS RecencyScore,
       CASE
           WHEN Frequency >= 10 THEN 'High'
           WHEN Frequency BETWEEN 5 AND 9 THEN 'Medium'
           ELSE 'Low'
       END AS FrequencyScore,
       CASE
           WHEN Monetary >= 500 THEN 'High'
           WHEN Monetary BETWEEN 200 AND 499 THEN 'Medium'
           ELSE 'Low'
       END AS MonetaryScore
FROM Combinedrfm;


