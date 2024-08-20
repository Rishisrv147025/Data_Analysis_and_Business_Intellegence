---------Verifying table structure
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'NSEI';

-------Checking for top values in open, high, low, close.
SELECT TOP 10 [Open], [Close], [Volume], [Low], [High]
FROM NSEI_Data;


--------Finding min, max, total and average value
SELECT 
    MIN([Open]) AS MinOpen,
    MAX([Open]) AS MaxOpen,
    AVG([Open]) AS AvgOpen,
    MIN([Close]) AS MinClose,
    MAX([Close]) AS MaxClose,
    AVG([Close]) AS AvgClose,
    SUM([Volume]) AS TotalVolume
FROM NSEI;

---Monthly Avg. price
SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    AVG([Open]) AS Avg_Open,
    AVG([High]) AS Avg_High,
    AVG([Low]) AS Avg_Low,
    AVG([Close]) AS Avg_Close
FROM NSEI_Data
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;

----Change for Trends:
SELECT 
    Date, 
    [Close],
    CASE 
        WHEN [Close] > LAG([Close]) OVER (ORDER BY Date) THEN 'Up'
        WHEN [Close] < LAG([Close]) OVER (ORDER BY Date) THEN 'Down'
        ELSE 'No Change'
    END AS Trend
FROM NSEI_Data;