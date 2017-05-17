
SELECT "schema_migrations".* FROM "schema_migrations"

--  Organization Load (0.5ms)
SELECT "organizations".* FROM "organizations"  WHERE "organizations"."name" = 'localmumuki' LIMIT 1
--  Organization Load (0.7ms)
SELECT  "organizations".* FROM "organizations"  WHERE "organizations"."name" = 'central' LIMIT 1
--  Rendered layouts/_error.html.erb (0.7ms)
--  Rendered errors/not_found.html.erb within layouts/application (63.7ms)
--  Book Load (1.1ms)
SELECT  "books".* FROM "books"  WHERE "books"."id" = 27 LIMIT 1

select * from languages;

select * from organizations;

select * from lessons;

select * from guides where id = 156;

select * from chapters;

select * from exercises
where description like '%Gobstones y JavaScript tienen mucho en común%';


-- Language Load (0.4ms)

select * from languages where id > 10;

SELECT  "languages".* FROM "languages"  WHERE "languages"."id" = 15 LIMIT 1;
-- Guide Load (0.5ms)
SELECT  "guides".* FROM "guides"  WHERE "guides"."id" = 116 LIMIT 1;

select * from exercises where id = 1401;

select * from books;