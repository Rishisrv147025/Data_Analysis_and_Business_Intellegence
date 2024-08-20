SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'googleplaystore';

-----Genre app
SELECT DISTINCT Genres 
FROM googleplaystore;

----Total App count
SELECT COUNT(*) AS TotalApps 
FROM googleplaystore;

----Cheking for available categories.
SELECT COUNT(DISTINCT Category) AS UniqueCategories 
FROM googleplaystore;

----Checking for content rating
SELECT Content_Rating, COUNT(*) AS AppCount 
FROM googleplaystore
GROUP BY Content_Rating 
ORDER BY AppCount DESC;

-----Top app by reviews.
SELECT TOP 10 
    App, 
    Reviews 
FROM AppData 
WHERE ISNUMERIC(Reviews) = 1 
ORDER BY CAST(Reviews AS INT) DESC;


----Recent update
SELECT COUNT(*) AS RecentUpdates 
FROM googleplaystore
WHERE Last_Updated > DATEADD(YEAR, -1, GETDATE());


----Ratings for each app
SELECT App, Rating 
FROM googleplaystore
WHERE Rating IS NOT NULL;


---Rating with N/A value.
SELECT TOP 5 
    App, 
    Rating 
FROM googleplaystore
WHERE Rating IS NOT NULL 
ORDER BY Rating DESC;

---Count of app by category
SELECT Category, COUNT(*) AS AppCount 
FROM googleplaystore 
GROUP BY Category 
ORDER BY AppCount DESC;


----Free and paid app
SELECT Type, COUNT(*) AS AppCount 
FROM googleplaystore 
GROUP BY Type 
ORDER BY AppCount DESC;


