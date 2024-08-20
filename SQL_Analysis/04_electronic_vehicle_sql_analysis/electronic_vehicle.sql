---------Verifying table structure
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ElectronicVehicles';



----Count of Vehicle by make
SELECT Make, COUNT(*) AS VehicleCount
FROM ElectronicVehicles
GROUP BY Make
ORDER BY VehicleCount DESC;


----Avg base mrp by vehicle type
SELECT ElectricVehicleType, AVG(BaseMSRP) AS AverageMSRP
FROM ElectronicVehicles
GROUP BY ElectricVehicleType
ORDER BY AverageMSRP DESC;


----Maximum electric range of vehicle
SELECT Make, Model, ElectricRange
FROM ElectronicVehicles
WHERE ElectricRange = (SELECT MAX(ElectricRange) FROM ElectronicVehicles);


-----Distribution of electric vehicle by state
SELECT State, COUNT(*) AS VehicleCount
FROM ElectronicVehicles
GROUP BY State
ORDER BY VehicleCount DESC;


-------Electric Vehicles Eligible for Clean Alternative Fuel Vehicle (CAFV)
SELECT *
FROM ElectronicVehicles
WHERE CleanAlternativeFuelVehicleEligibility = 'Eligible';


------Count of Vehicle by country
SELECT County, COUNT(*) AS VehicleCount
FROM ElectronicVehicles
GROUP BY County
ORDER BY VehicleCount DESC;


-----Vehicle with greater range than a specific value.
SELECT *
FROM ElectronicVehicles
WHERE ElectricRange > 200; 


SELECT ModelYear, COUNT(*) AS VehicleCount
FROM ElectronicVehicles
GROUP BY ModelYear
ORDER BY ModelYear;


SELECT ElectricRange, BaseMSRP
FROM ElectronicVehicles
ORDER BY ElectricRange;


SELECT *
FROM ElectronicVehicles
WHERE County = 'King'; 