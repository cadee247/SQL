SELECT * FROM teachers;
SELECT first_name FROM teachers;
SELECT first_name, last_name FROM teachers;
SELECT DISTINCT salary FROM teachers;
ALTER TABLE teachers ADD COLUMN favorite_snack TEXT;

UPDATE teachers
SET favorite_snack = CASE
  WHEN first_name = 'Lee' THEN 'Jelly Beans'
  WHEN first_name = 'Betty' THEN 'Chips'
  WHEN first_name = 'Janet' THEN 'Chocolate'
  ELSE 'Granola Bars'
END;
SELECT DISTINCT first_name, last_name, favorite_snack
FROM teachers
ORDER BY favorite_snack;