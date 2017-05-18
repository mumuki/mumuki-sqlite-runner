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

select * from lessons;

select * from assignments;

select * from guides
where id = 116
where name like '%Funciones y Tipos de Datos, revisado%';

select * from exercises where id = 1401 or id = 1402;

select * from paths;

select * from books order by name asc;

select * from chapters;

select * from topics;

select ch.id, ch.number, ch.book_id, b.name, b.description, ch.topic_id, t.name, t.description
from chapters as ch
left join books as b on b.id = ch.book_id
left join topics as t on t.id = ch.topic_id
-- where t.name like '%Imperativ%'
where b.id = 27

select * from usages
where item_id in (116, 165);


SELECT  "usages".* 
FROM "usages"  
WHERE "usages"."item_id" = 33 
AND "usages"."item_type" = 'Topic' 
AND "usages"."organization_id" = 1  
ORDER BY "usages"."id" 
ASC LIMIT 1  
-- [["item_id", 33], ["item_type", "Topic"]]

select * from usages order by item_type
where item_type = 'Chapter';