---------Verifying table structure
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'FSI2023DOWNLOAD';


-- Get total number of records
SELECT COUNT(*) AS TotalRecords FROM FSI2023DOWNLOAD;

-- Get the average Total score across all countries
SELECT AVG(Total) AS AverageTotal FROM FSI2023DOWNLOAD;

-- Get the minimum and maximum Total score
SELECT MIN(Total) AS MinTotal, MAX(Total) AS MaxTotal FROM FSI2023DOWNLOAD;


-- Average Total score per year
SELECT Year, AVG(Total) AS AverageTotal
FROM FSI2023DOWNLOAD
GROUP BY Year
ORDER BY Year;

-- Count of countries by year
SELECT Year, COUNT(DISTINCT Country) AS CountryCount
FROM FSI2023DOWNLOAD
GROUP BY Year
ORDER BY Year;


-- Count of countries in each rank
SELECT Rank, COUNT(*) AS CountryCount
FROM FSI2023DOWNLOAD
GROUP BY Rank
ORDER BY Rank;


-- Top 5 countries with the highest Total score
SELECT TOP 5 Country, Total
FROM FSI2023DOWNLOAD
ORDER BY Total DESC;

-- Top 5 countries with the lowest Total score
SELECT TOP 5 Country, Total
FROM FSI2023DOWNLOAD
ORDER BY Total ASC;


-- Average scores for demographic pressures over the years
SELECT Year, AVG(DemographicPressures) AS AvgDemographicPressures
FROM FSI2023DOWNLOAD
GROUP BY Year
ORDER BY Year;

-- Countries with high economic inequality
SELECT Country, EconomicInequality
FROM FSI2023DOWNLOAD
WHERE EconomicInequality > (SELECT AVG(EconomicInequality) FROM CountryData)
ORDER BY EconomicInequality DESC;