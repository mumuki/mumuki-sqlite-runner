## Start Engines

### Start Vagrant

```bash
$ cd ~/dev/mumuki
~/dev/mumuki$ vagrant up
```

### Start Laboratory

```bash
~/dev/mumuki$ vagrant ssh
vagrant@ubuntu:~# cd mumuki/laboratory
vagrant@ubuntu:mumuki/laboratory# bundle exec rails s
```

### Start SQLite Runner

```bash
~/dev/mumuki$ vagrant ssh
vagrant@ubuntu:~# cd mumuki/runners/sqlite
vagrant@ubuntu:mumuki/runners/sqlite# bundle exec rackup -p 4567
```

### Create SQLite Language

```bash
/vagrant/laboratory/ $ rails console
```

```ruby
# Create SQLite Language & Map to sqlite-runner (dev)
langs = Language.all
sqlite = langs.last.dup
sqlite.name = 'sqlite'
sqlite.runner_url = 'http://localhost:4567'
sqlite.extension = 'sql'
sqlite.save
```

### Create SQL Chapter inside of "Aprendé a programar" Book

```ruby
# Clone & adapt a Topic
imp = Topic.find(10) # programación imperativa
bd = imp.dup
bd.name = 'Bases de Datos'
bd.description = 'Es el turno de las Bases de Datos. Vamos a ver como interactuar con motores de **Bases de Datos Relaciones** a través del lenguaje [SQL](https://es.wikipedia.org/wiki/SQL)'
bd.slug = 'mumuki/mumuki-bases-de-datos'
bd.save # id = 33

# second Add Topic as Chapter of Book
Chapter.where('topic_id = 10') # to watch structure
bd_ch = Chapter.new
bd_ch.number = 6
bd_ch.book_id = 27
bd_ch.topic_id = bd.id
bd_ch.save # id = 40
```

### Create a Guide into a new Lesson

```ruby
# Clone a Guide
guide = Guide.find(116) # Funciones y Tipos de Datos, revisado
bd_guide = guide.dup
bd_guide.name = 'MQL Pilot'
bd_guide.description = '¡Hola! Vamos a ver como funciona esto de escribir SQL en Mumuki.'
bd_guide.language_id = sqlite.id
bd_guide.extra = ''
bd_guide.corollary = '¡Excelente! :clap: :cactus:'
bd_guide.slug = 'unq/mql'
bd_guide.authors = 'Leandro Di Lorenzo, Mumuki Project'
bd_guide.save # id = 165

# Create new Lesson
bd_lesson = Lesson.new
bd_lesson.guide_id = bd_guide.id
bd_lesson.topic_id = bd.id
bd_lesson.number = 1
bd_lesson.save # id = 120

# Set Usage Topic (?)
usage = Usage.where('item_id = 10').first
bd_topic_usage = usage.dup
bd_topic_usage.slug = bd.slug
bd_topic_usage.item_type = 'Topic'
bd_topic_usage.item_id   = bd.id
bd_topic_usage.parent_item_type = 'Chapter'
bd_topic_usage.parent_item_id   = bd_ch.id
bd_topic_usage.save

# Set Usage Guide (?)
usage = Usage.where('item_id = 116').first
bd_usage = usage.dup
bd_usage.slug = bd_guide.slug
bd_usage.item_id = bd_guide.id
bd_usage.item_type = 'Guide'
bd_usage.parent_item_id = bd_lesson.id
bd_usage.parent_item_type = 'Lesson'
bd_usage.save
```

### Create SQLite exercise

```ruby
js = Exercise.find(856)
ej1 = js.dup
ej1.name = 'El del Runner'
ej1.description = <<-MD
Ejercicio base usado en el primer test de integración del runner de sqlite.

Se cuenta con una base de datos llamada `test1` con la siguiente estructura:

 - **id**: _PK_, _AUTO_
 - **name**: _VARCHAR(200)_, _NOT NULL_

La tabla `test1` contiene 2 registros:

   id | name
  ----|--------
    1 | Name 1 
    2 | Name 2 

El ejercicio requiere generar una consulta que retorne todos los registros de la tabla.
MD
ej1.test = '-- NONE'
ej1.language_id = sqlite.id
ej1.guide_id = bd_guide.id
ej1.hint = 'Escribí `select * from test1;`'
ej1.extra = <<-SQL
-- CREATE
CREATE TABLE test1 (
id integer primary key,
name varchar(200) NOT NULL
);
-- INSERTS
INSERT INTO test1 (name) values ('Name 1');
INSERT INTO test1 (name) values ('Name 2');
-- SELECT-DOC
select * from test1;
SQL
ej1.number = 1
ej1.corollary = 'Va queriendo...'
ej1.extra_visible = true
ej1.save # id = 1402
```
