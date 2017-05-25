-- #init
create table test (
  id INTEGER PRIMARY KEY,
  name varchar(200) not null
);
-- #solution
select name from test
-- DATASET
insert into test (name) values ('Test 1.1');
insert into test (name) values ('Test 1.2');
insert into test (name) values ('Test 1.3');
-- DATASET
insert into test (name) values ('Test 2.1');
insert into test (name) values ('Test 2.2');
insert into test (name) values ('Test 2.3');
-- #student
select * from test;