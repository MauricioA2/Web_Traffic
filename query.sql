-- Create a table with standardize column names
CREATE TABLE traffic(
    date DATE NOT NULL,
    device_category VARCHAR(20) NOT NULL,
    browser VARCHAR(50) NOT NULL,
    visitors INT NOT NULL,
    sessions INT,                  
    bounce_rate DECIMAL(5,2)        
);

SElECT * from traffic
lIMIT 10;

-- Explore data, check data consistency
SELECT DISTINCT device_category
FROM traffic;

SELECT DISTINCT browser
FROM traffic
ORDER BY browser;

-- These values are typically the same browsers.
SELECT DISTINCT browser
FROM traffic
WHERE browser LIKE '%Firefox%'
OR browser LIKE '%Mozilla%'

SELECT DISTINCT browser
FROM traffic
WHERE browser LIKE '%Safari%'

-- Updating the browers to have better consistency
UPDATE traffic
SET browser = 'Mozilla'
WHERE browser LIKE '%Mozilla%';

UPDATE traffic
SET browser = 'Safari'
WHERE browser LIKE '%Safari%';

UPDATE traffic
SET browser = 'BlackBerry'
WHERE browser LIKE '%BlackBerry%';

UPDATE traffic
SET browser = 'Bluebeam Revu Browser'
WHERE browser LIKE '%Bluebeam Revu Browser%';

UPDATE traffic
SET browser = 'Samsung'
WHERE browser LIKE '%Samsung%' OR browser LIKE '%samsung%';

UPDATE traffic
SET browser = 'Nintendo Browswer'
WHERE browser LIKE '%Nintendo Browswer%';

UPDATE traffic
SET browser = 'Playstation'
WHERE browser LIKE '%Playstation%';

UPDATE traffic
SET browser = 'Nintendo'
WHERE browser LIKE '%Nintendo%';

UPDATE traffic
SET browser = 'WeSEE'
WHERE browser LIKE '%WeSEE%';

UPDATE traffic
SET browser = 'UC Browser'
WHERE browser LIKE '%UC%';

-- Handle undefined values
UPDATE traffic
SET browser = 'NotDefined'
WHERE browser = '(not set)'

-- Review changes
SELECT DISTINCT browser
FROM traffic
ORDER BY browser

-- Checking for duplicates 
SELECT *, COUNT(*) AS total
FROM traffic
GROUP BY date, device_category, browser, visitors, sessions, bounce_rate
HAVING COUNT(*) > 1;

-- Deleting duplicates
WITH duplicates AS (
    SELECT ctid, 
           ROW_NUMBER() OVER (PARTITION BY date, device_category, browser, visitors, sessions, bounce_rate) AS row_num
    FROM traffic
)
DELETE FROM traffic
WHERE ctid IN (
    SELECT ctid
    FROM duplicates
    WHERE row_num > 1
);

-- Final data review before analysis or reporting
SELECT
	MIN(date) AS start_date,
	MAX(date) AS end_date,
	COUNT(DISTINCT device_category) AS device_count,
	count(DISTINCT browser) AS browser_count,
	MIN(visitors) AS min_visitors,
	MAX(visitors) AS max_visitors,
	MIN(sessions) AS min_sessions,
	MAX(sessions) AS max_sessions,
	MIN(bounce_rate) AS min_bounce,
	MAX(bounce_rate) AS max_bounce
FROM traffic; 

SELECT *
FROM traffic;

-- Ready for further exploration and visualization