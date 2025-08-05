-- 🧱 Create the table
CREATE TABLE char_data_types (
  varchar_column VARCHAR(100)
);

-- 📥 Insert sample data
INSERT INTO char_data_types (varchar_column)
VALUES 
  ('abc'),
  ('ABC'),
  ('Abc'),
  ('hello there'),
  ('hi over there');

-- 🔄 Update rows where varchar_column matches 'ABC' (case-insensitive)
UPDATE char_data_types
SET varchar_column = upper('abc')
WHERE varchar_column ILIKE 'ABC';

-- ✂️ Trim 'C' from the string 'abc' for matching rows
SELECT trim('C' FROM 'abc')
FROM char_data_types
WHERE varchar_column ILIKE 'ABC';

-- 🔍 Find position of substring 'llo ' in 'hello there'
SELECT position('llo ' IN 'hello there');

-- ↪️ Get 0 characters from the right of 'hi over there'
SELECT right('hi over there', 0);

-- 🔢 Extract the 4-digit year using regex
SELECT substring('The game starts at 7 p.m. on May 2, 2019.' FROM '[0-9]{4}');









DROP TABLE IF EXISTS subscriber_data;



-- Drop the table if it already exists
DROP TABLE IF EXISTS subscriber_data;

-- Create the table with constraints
CREATE TABLE subscriber_data (
  subscriber_id SERIAL PRIMARY KEY,

  user_name TEXT NOT NULL 
    CONSTRAINT username_capital CHECK (user_name ~ '^[A-Z][a-z]*$'),

  numeric_password TEXT NOT NULL 
    CONSTRAINT password_numeric CHECK (numeric_password ~ '^[0-9]+$'),

  email_address TEXT NOT NULL 
    CONSTRAINT email_valid CHECK (
      email_address ~* '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'
    )
);

-- Insert valid sample data
INSERT INTO subscriber_data (user_name, numeric_password, email_address)
VALUES 
  ('CAdee', '123456', 'cadee@gmail.com'),
  ('Liam', '987654321', 'liam@luxegem.co.za'),
  ('Sophie', '20252025', 'sophie.rose@jewelmail.com');

-- Select all rows from the table
SELECT * FROM subscriber_data;




 SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & sitting');
 SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & running');









-- 🧑‍💼 Create a temporary table of names with suffixes
CREATE TEMP TABLE people (
  full_name TEXT
);

-- 📝 Insert sample names with various suffix formats
INSERT INTO people (full_name) VALUES
  ('Alvarez, Jr.'),
  ('Williams, Sr.'),
  ('Taylor, III'),
  ('Morgan Jr.'),
  ('Lee Sr.'),
  ('Jordan, PhD');

-- 🧹 Clean names and extract suffixes using regex
SELECT 
  -- Remove comma before suffix (e.g., "Alvarez, Jr." → "Alvarez Jr.")
  replace(full_name, ', ', ' ') AS cleaned_name,

  -- Extract suffix using regex based on format
  CASE 
    WHEN full_name ~ ',\s*(Jr\.|Sr\.|III|PhD)' THEN regexp_replace(full_name, '^.*,\s*(\w+\.*)$', '\1')
    WHEN full_name ~ '\s(Jr\.|Sr\.|III|PhD)$' THEN regexp_replace(full_name, '^.*\s(\w+\.*)$', '\1')
    ELSE NULL
  END AS suffix
FROM people;

-- 🧪 Alternative: Only process names with comma suffixes
SELECT 
  replace(full_name, ', ', ' ') AS cleaned_name,
  
  -- Extract suffix from comma format only
  regexp_replace(full_name, '^.*,\s*(\w+\.)$', '\1') AS suffix
FROM people
WHERE full_name ~ ',\s*(Jr\.|Sr\.)';

-- 🗣️ Create a temporary table for State of the Union speeches
CREATE TEMP TABLE state_of_union (
  president TEXT,
  year INT,
  speech_text TEXT
);

-- 📝 Insert a sample speech
INSERT INTO state_of_union (president, year, speech_text) VALUES
('Barack Obama', 2016, 
 'Tonight, we turn the page. The economy is growing. Jobs are being created. Innovation is thriving.');

-- 📊 Count unique words with 5+ characters, ignoring punctuation
SELECT COUNT(DISTINCT lower(trim(trailing '.' FROM trim(trailing ',' FROM word)))) AS unique_words
FROM (
  -- Split speech into words using whitespace
  SELECT regexp_split_to_table(speech_text, '\s+') AS word
  FROM state_of_union
  WHERE president = 'Barack Obama' AND year = 2016
) AS words
-- Filter for words with 5 or more characters
WHERE char_length(trim(trailing '.' FROM trim(trailing ',' FROM word))) >= 5;

-- 📚 Create a temporary table of documents for text search
CREATE TEMP TABLE documents (
  title TEXT,
  content TEXT
);

-- 📝 Insert sample documents with economic and job-related content
INSERT INTO documents (title, content) VALUES
('Economic Outlook', 'The economy is improving and jobs are increasing across sectors.'),
('Healthcare Reform', 'Jobs in healthcare are expanding, but the economy remains uncertain.'),
('Education Policy', 'Education and innovation drive long-term economic growth.');

-- 🔍 Rank documents using ts_rank (basic relevance)
SELECT 
  title, 
  ts_rank(to_tsvector(content), to_tsquery('economy & jobs')) AS rank
FROM documents
ORDER BY rank DESC;

-- 🔍 Bonus: Rank documents using ts_rank_cd (cover density)
-- This favors documents where search terms are closer together
SELECT 
  title, 
  ts_rank_cd(to_tsvector(content), to_tsquery('economy & jobs')) AS rank
FROM documents
ORDER BY rank DESC;