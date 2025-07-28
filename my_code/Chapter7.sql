CREATE TABLE natural_key_composite_example (
    student_id varchar(10),
    school_day date,
    present boolean,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

DROP TABLE  natural_key_composite_example;
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES ('775', '2017-01-20', TRUE);

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES ('775', '2017-01-28', TRUE);

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES ('775', '2017-02-01', FALSE);
SELECT * FROM natural_key_composite_example;

CREATE TABLE licenses (
    license_id varchar(10),
    first_name varchar(50),
    last_name varchar(50),
 CONSTRAINT licenses_key PRIMARY KEY (license_id)
 );
 CREATE TABLE registrations (
    registration_id varchar(10),
    registration_date date,
  license_id varchar(10) REFERENCES licenses (license_id),
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
 );

 INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '2017-03-17', 'T229901');

SELECT * FROM licenses;
SELECT * FROM registrations



CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    price NUMERIC
);


CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER
);
-- Ensure price is positive
ALTER TABLE products
ADD CONSTRAINT price_positive CHECK (price > 0);

-- Insert a product
INSERT INTO products (name, price) VALUES ('Laptop Stand', 45.00);

-- Insert an order for that product
INSERT INTO orders (product_id, quantity) VALUES (1, 2);

SELECT * FROM products;
SELECT * FROM orders;
