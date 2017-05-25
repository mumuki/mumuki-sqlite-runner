## Expected input

```sqlite
-- [init]
-- CREATE
create table ...;
insert into ...;
  -- -- # any other sql sentences needed to prepare field
-- [tests]
-- SOLUTION
select ... from ...;
-- DATASET-TEST-1
insert into ...;
-- DATASET-TEST-2
insert into ...;
...
-- [student]
select ... from ...;
 -- -- # potentially could be possible to execute inserts, updates or any other
 -- -- # sql sentences, but (for now at least) it should be necessary to end
 -- -- # content program with an <select> query to be able to verify results.
```

# Expected output when successful

```
-- [solutions] # teacher query results
-- SOLUTION-1
id|name|age
 1|Foo|10
-- SOLUTION-2
id|name|age
 1|Foo|10
 3|Bar|15
-- [results]  # student query results
-- SOLUTION-1 # correct
id|name|age
 1|Foo|10
-- SOLUTION-2 # wrong
id|name|age
 1|Foo|10
 4|Baz|17
```

# Expected output when error

```
-- [error]
Error: ...
```