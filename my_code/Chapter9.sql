CREATE TABLE meat_poultry_egg_inspect (
    est_number varchar(50) CONSTRAINT est_number_key PRIMARY KEY,
    company varchar(100),
    street varchar(100),
    city varchar(30),
    st varchar(2),
    zip varchar(5),
    phone varchar(14),
    grant_date date,
    activities text,
    dbas text
);

COPY meat_poultry_egg_inspect
FROM 'C:\Users\rouss\OneDrive\Desktop\code-college\SQL\src\practical-sql-main\practical-sql-main\Chapter_09\MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

CREATE INDEX company_idx ON meat_poultry_egg_inspect (company);

SELECT company,
       street,
       city,
       st,
       count(*) AS address_count
 FROM meat_poultry_egg_inspect
 GROUP BY company, street, city, st
 HAVING count(*) > 1
 ORDER BY company, street, city, st;

WITH ranked_states AS (
  SELECT st, 
         COUNT(*) OVER (PARTITION BY st) AS st_count,
         ROW_NUMBER() OVER (PARTITION BY st) AS rn
  FROM meat_poultry_egg_inspect
)
SELECT st, st_count
FROM ranked_states
WHERE rn = 1;

SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_inspect
GROUP BY st
ORDER BY st;


SELECT company,  
       count(*) AS company_count  
FROM meat_poultry_egg_inspect  
GROUP BY company  
ORDER BY company ASC;


SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY length(zip)
ORDER BY length(zip) ASC;


SELECT st,  
       count(*) AS st_count  
FROM meat_poultry_egg_inspect  
WHERE length(zip) < 5  
GROUP BY st  
ORDER BY st ASC;


 CREATE TABLE meat_poultry_egg_inspect_backup AS
 SELECT * FROM meat_poultry_egg_inspect;

  SELECT 
    (SELECT count(*) FROM meat_poultry_egg_inspect) AS original,
    (SELECT count(*) FROM meat_poultry_egg_inspect_backup) AS backup;

	ALTER TABLE meat_poultry_egg_inspect ADD COLUMN st_copy varchar(2);
 UPDATE meat_poultry_egg_inspect
  SET st_copy = st;

   SELECT st,
       st_copy
 FROM meat_poultry_egg_inspect
 ORDER BY st;

 DELETE FROM meat_poultry_egg_inspect
WHERE length(zip) < 5;

DROP TABLE meat_poultry_egg_inspect;
SELECT * 
FROM meat_poultry_egg_inspect 
WHERE length(zip) < 5;


SELECT * FROM meat_poultry_egg_inspect
LIMIT 10;

-- Before delete
SELECT count(*) FROM meat_poultry_egg_inspect;

-- After delete
SELECT count(*) FROM meat_poultry_egg_inspect;
