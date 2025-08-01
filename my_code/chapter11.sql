 SELECT 
    date_part('year', '2019-12-01 18:37:12 EST'::timestamptz) AS "year",
    date_part('month', '2019-12-01 18:37:12 EST'::timestamptz) AS "month",
    date_part('day', '2019-12-01 18:37:12 EST'::timestamptz) AS "day",
    date_part('hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "hour",
    date_part('minute', '2019-12-01 18:37:12 EST'::timestamptz) AS "minute",
    date_part('seconds', '2019-12-01 18:37:12 EST'::timestamptz) AS "seconds",
    date_part('timezone_hour', '2019-12-01 18:37:12 EST'::timestamptz) AS "tz",
    date_part('week', '2019-12-01 18:37:12 EST'::timestamptz) AS "week",
    date_part('quarter', '2019-12-01 18:37:12 EST'::timestamptz) AS "quarter",
    date_part('epoch', '2019-12-01 18:37:12 EST'::timestamptz) AS "epoch";

SELECT
    date_part('year', TIMESTAMPTZ '2025-07-31 09:00:00+02') AS "Y",
    date_part('month', TIMESTAMPTZ '2025-07-31 09:00:00+02') AS "M",
    date_part('day', TIMESTAMPTZ '2025-07-31 09:00:00+02') AS "D",
    date_part('hour', TIMESTAMPTZ '2025-07-31 09:00:00+02') AS "H";

SELECT 
  extract(year FROM TIMESTAMPTZ '2025-07-31 09:00:00+02') AS "year";

	SELECT 
  make_timestamptz(2025, 2, 22, 18, 4, 30.3, 'Africa/Johannesburg') AS full_ts;


  CREATE TABLE current_time_example (
    time_id bigserial,
  current_timestamp_col timestamp with time zone,
  clock_timestamp_col timestamp with time zone
 );
 INSERT INTO current_time_example (current_timestamp_col, clock_timestamp_col)
  (SELECT current_timestamp,
            clock_timestamp()
     FROM generate_series(1,1000));
 SELECT * FROM current_time_example;

 SHOW timezone;

 SHOW port;

 SHOW all;

 SELECT clock_timestamp();

  SELECT * FROM pg_timezone_names
 WHERE name LIKE 'Europe%';

 SET timezone TO 'US/Eastern';

SET timezone TO 'US/Pacific';

CREATE TABLE time_zone_test (
    test_date timestamp with time zone
);
INSERT INTO time_zone_test VALUES ('2020-01-01 4:00');

SELECT test_date
FROM time_zone_test;

SET timezone TO 'US/Eastern';


CREATE TABLE nyc_yellow_taxi_trips_2016_06_01 (
    trip_id bigserial PRIMARY KEY,
    vendor_id varchar(1) NOT NULL,
    tpep_pickup_datetime timestamp with time zone NOT NULL,
    tpep_dropoff_datetime timestamp with time zone NOT NULL,
    passenger_count integer NOT NULL,
    trip_distance numeric(8,2) NOT NULL,
    pickup_longitude numeric(18,15) NOT NULL,
    pickup_latitude numeric(18,15) NOT NULL,
    rate_code_id varchar(2) NOT NULL,
    store_and_fwd_flag varchar(1) NOT NULL,
    dropoff_longitude numeric(18,15) NOT NULL,
    dropoff_latitude numeric(18,15) NOT NULL,
    payment_type varchar(1) NOT NULL,
    fare_amount numeric(9,2) NOT NULL,
    extra numeric(9,2) NOT NULL,
    mta_tax numeric(5,2) NOT NULL,
    tip_amount numeric(9,2) NOT NULL,
    tolls_amount numeric(9,2) NOT NULL,
    improvement_surcharge numeric(9,2) NOT NULL,
    total_amount numeric(9,2) NOT NULL
);

COPY nyc_yellow_taxi_trips_2016_06_01 (
    vendor_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    pickup_longitude,
    pickup_latitude,
    rate_code_id,
    store_and_fwd_flag,
    dropoff_longitude,
    dropoff_latitude,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount
   )
FROM 'C:\Users\rouss\OneDrive\Desktop\code-college\SQL\src\practical-sql-main\practical-sql-main\Chapter_11\yellow_tripdata_2016_06_01.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

CREATE INDEX tpep_pickup_idx
ON nyc_yellow_taxi_trips_2016_06_01 (tpep_pickup_datetime);

SELECT count(*) FROM nyc_yellow_taxi_trips_2016_06_01;

SELECT test_date
FROM time_zone_test;

SELECT test_date AT TIME ZONE 'Asia/Seoul'
FROM time_zone_test;

 SELECT count(*) FROM nyc_yellow_taxi_trips_2016_06_01;

SELECT
  date_part('hour', tpep_pickup_datetime) AS trip_hour,
  count(*) AS trip_count
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour
ORDER BY trip_count DESC;