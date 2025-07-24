-- 1️⃣ Create the table
CREATE TABLE char_data_types (
    varchar_column VARCHAR(10),
    char_column CHAR(10),
    text_column TEXT
);

-- 2️⃣ Insert sample data
INSERT INTO char_data_types
VALUES 
    ('abc', 'abc', 'abc'),
    ('defghi', 'defghi', 'defghi');

SELECT * FROM char_data_types;	

CREATE TABLE people (
 id serial,
 person_name varchar(100)
);
INSERT INTO people (id, person_name)
VALUES (1234567890, 'Cadee Rousseau');

SELECT * FROM dummy;

CREATE TABLE date_time_types (
    timestamp_column TIMESTAMP WITH TIME ZONE,
    interval_column INTERVAL
);

INSERT INTO date_time_types
VALUES
    ('2010-12-31 01:00 EST', '2 days'),
    ('2010-12-31 01:00 -4', '1 month'),
    ('2010-12-31 01:00 Australia/Melbourne', '1 century'),
    ('now()', '1 week');

SELECT * FROM date_time_types;
