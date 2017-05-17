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
langs = Languages.all
sqlite = langs.last.dup
sqlite.name = 'sqlite'
sqlite.runner_url = 'http://localhost:4567'
sqlite.extension = 'sql'
sqlite.save
```

### Create an SQLite exercise

```ruby
ejercicio = Organization.central.book.chapters.first.lessons.first.exercises.first
ejercicio.update! language: 'sql', test: '....'
```

```ruby
js = Exercise.find(856)
sql = js.dup
sql.name = 'SQL dup: ' << js.name
sql.test = '-- NONE'
sql.language_id = 15
sql.extra = <<-SQL
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
sql.extra_visible = true
sql.save
```
