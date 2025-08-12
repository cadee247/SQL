CREATE TABLE vacuum_test (
    integer_column integer
 );

  SELECT pg_size_pretty(
 pg_total_relation_size('vacuum_test')
       );

 INSERT INTO vacuum_test
 SELECT * FROM generate_series(1,500000);

 SELECT * FROM vacuum_test

 UPDATE vacuum_test
 SET integer_column = integer_column + 1;

 VACUUM

 SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

VACUUM
DELETE FROM vacuum_test
WHERE integer_column = 2;

 VACUUM FULL vacuum_test;

  SHOW config_file;