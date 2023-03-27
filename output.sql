BULK
INSERT OldestLoggedHistoricalEntries
FROM 'OldestLoggedHistoricalEntries.csv'
WITH
(FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n')

BULK
INSERT TimeWarpData
FROM 'TimeWarpData.csv'
WITH
(FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n')

BULK
INSERT Providers
FROM 'Providers.csv'
WITH
(FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n')
