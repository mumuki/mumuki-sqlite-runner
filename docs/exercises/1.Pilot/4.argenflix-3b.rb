# Create SQLite exercise

# Get Relations
language = Language.find_by(name: 'sqlite')
guide = Guide.find_by(name: 'MQL Pilot')

ej1 = Exercise.find_by(name: 'El del Runner')
ej4 = ej1.dup
ej4.name = 'Argenflix 3.b)'
ej4.description = <<-MD
> Ejercicio adaptado del TP "Argenflix" tomado en BBDD el 1s2017

Dadas las relaciones:

**pelicula**

```yaml
id_pelicula: INT PK
nombre_pelicula: VARCHAR(40)
genero: VARCHAR(20)
duracion: INT
calificacion: INT
nombre_actor: VARCHAR(50) FK
nombre_director: VARCHAR(50) FK
```

**director**

```yaml
nombre_director: VARCHAR(50) PK
edad: INT
nacionalidad: VARCHAR(20)
```

Se pide:

> Obtener la cantidad películas agrupadas por nacionalidad del director.
> El resultado debe tener sólo los campos **nacionalidad** y **cantidad**.
> _No se deben tener en cuenta películas cuyos directores no tengan nacionalidad_.

MD
ej4.test = <<-YAML
solution_type: query
solution_query: |
  SELECT nacionalidad, count(*) AS cantidad
  FROM pelicula p
  LEFT JOIN director d ON p.nombre_director = d.nombre_director
  WHERE nacionalidad is not null
  GROUP BY nacionalidad
  ORDER BY cantidad DESC;
examples:
  -
    data: |
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Alejandro Doria', 72, 'Argentina', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Bruno Heller', 55, 'Inglesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Charles Marquis Warren', 78, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Chris Weitz', 46, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Chuck Lorre', 62, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('David Crane', 57, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('David Lynch', 69, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Donald Bellisario', 50, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Fred Hamilton', 57, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Gareth Edwards', 50, 'Inglesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('George R R Martin', 66, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Glen Larson', 80, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Hayao Miyazaki', 74, 'Japonesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Jean-Pierre Jeunet', 61, 'Francesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('John Lasseter', 58, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Joss Whedon', 51, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Juan Jose Campanella', 55, 'Argentina', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Linwood Boomer', 63, 'Canadiense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('M Night Shyamalan', 44, 'India', 'Haley Joel Osment');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Matt Groening', 61, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Michel Gondry', 52, 'Francesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Peter Farrely', 60, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Peter Jackson', 53, 'Neozelandesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Peter Weir', 70, 'Australiana', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Sam Mendes', 50, 'Inglesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Shinichiro Watanabe', 50, 'Japonesa', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Tim Burton', 56, 'Estadounidense', 'Johnny Depp');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Vince Gilligan', 48, 'Estadounidense', 'Bryan Cranston');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Woody Allen', 79, 'Estadounidense', 'Scarlett Johansson');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('David Fincher', 65, 'Estadounidense', 'Kevin Spacey');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Martin Scorsese', 58, 'Estadounidense', 'Leonardo DiCaprio');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Christopher Nolan', 61, 'Inglesa', 'Michael Caine');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Clint Eastwood', 57, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Anthony C. Ferrante', 65, 'Estadounidense', 'Ian Ziering');
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Mike Mendez', 60, 'Estadounidense', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Federico Barroso', 40, 'Argentina', NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Sean Penn', 60, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('John Dahl', 64, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('James McTeigue', 62, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Ridley Scott', 63, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Richard Kelly', 65, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Gus Van Sant', 74, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Todd Phillips', 57, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Eric Bress', 70, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Robert Rodriguez', 57, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Guy Ritchie', 60, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Jason Reitman', 51, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Ron Howard', 63, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Martin Brest', 70, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('John G. Avildsen', 83, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Sylvester Stallone', 81, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Gavin OConnor', 50, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Marc Webb', 63, NULL, NULL);
      INSERT INTO director (nombre_director, edad, nacionalidad, actor_fetiche) VALUES ('Quentin Tarantino', 65, NULL, NULL);
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (60, 'Lavalantula', 'Terror', 92, 8, 'Steve Guttenberg', 'Mike Mendez');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (59, 'Sharknado', 'Terror', 90, 6, 'Ian Ziering', 'Anthony C. Ferrante');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (61, 'Básicamente un pozo', 'Fantastico', 60, 9, 'Facundo Alcodoy', 'Federico Barroso');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (1, 'El Caballero de la Noche', 'Superheroes', 152, 9, 'Michael Caine', 'Christopher Nolan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (2, 'Amelie', 'Romantica', 122, 8, 'Audrey Tatou', 'Jean-Pierre Jeunet');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (3, 'Eterno Resplandor', 'Drama', 108, 8, 'Jim Carrey', 'Michel Gondry');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (4, 'The Truman Show', 'Drama', 103, 8, 'Jim Carrey', 'Peter Weir');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (5, 'Memento', 'Drama', 113, 8, 'Guy Pearce', 'Christopher Nolan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (6, 'La Comunidad del Anillo', 'Fantasia', 178, 7, 'Sean Bean', 'Peter Jackson');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (7, 'Interstellar', 'Ciencia Ficcion', 169, 6, 'Michael Caine', 'Christopher Nolan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (8, 'Toy Story', 'Animacion', 81, 8, 'Tom Hanks', 'John Lasseter');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (9, 'Sexto Sentido', 'Suspenso', 107, 8, 'Haley Joel Osment', 'M Night Shyamalan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (10, 'Tonto y Retonto', 'Comedia', 107, 5, 'Jim Carrey', 'Peter Farrely');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (11, 'El Joven Manos de Tijera', 'Fantasia', 105, 6, 'Johnny Depp', 'Tim Burton');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (12, 'La Brujula Dorada', 'Fantasia', 113, 5, 'Dakota Blue Richards', 'Chris Weitz');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (13, 'La Princesa Mononoke', 'Animacion', 134, 9, 'Gillian Anderson', 'Hayao Miyazaki');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (14, 'El extranho mundo de Jack', 'Animacion', 76, 6, 'Danny Elfman', 'Tim Burton');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (15, 'Scoop', 'Comedia Dramatica', 96, 7, 'Scarlett Johansson', 'Woody Allen');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (16, 'Los Vengadores', 'Superheroes', 143, 8, 'Scarlett Johansson', 'Joss Whedon');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (17, 'El Jinete Sin Cabeza', 'Terror', 105, 6, 'Johnny Depp', 'Tim Burton');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (18, 'Pandillas de Nueva York', 'Drama', 167, 8, 'Leonardo DiCaprio', 'Martin Scorsese');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (19, 'Charlie y la Fabrica de Chocolate', 'Comedia', 115, 5, 'Johnny Depp', 'Tim Burton');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (20, 'Godzilla', 'Mostruos', 123, 6, 'Bryan Cranston', 'Gareth Edwards');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (21, 'La Isla Siniestra', 'Thriller', 138, 7, 'Leonardo DiCaprio', 'Martin Scorsese');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (22, 'Metegol', 'Animacion', 106, 8, 'David Masajnik', 'Juan Jose Campanella');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (23, 'Belleza Americana', 'Drama', 122, 9, 'Kevin Spacey', 'Sam Mendes');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (24, 'Stuart Little Un Raton en la Familia', 'Familia', 84, 6, 'Hugh Laurie', 'M Night Shyamalan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (25, 'El camino de los suenhos', 'Drama', 147, 9, 'Naomi Watts', 'David Lynch');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (26, 'Esperando la Carroza', 'Comedia', 87, 9, 'Antonio Gasalla', 'Alejandro Doria');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (27, 'Pecados Capitales', 'Policial', 127, 9, 'Kevin Spacey', 'David Fincher');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (93, 'Inception', 'Action', NULL, NULL, 'Leonardo DiCaprio', 'Christopher Nolan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (94, 'Into the Wild', 'Drama', NULL, NULL, 'Emile Hirsch', 'Sean Penn');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (95, 'Rounders', 'Drama', NULL, NULL, 'Matt Damon', 'John Dahl');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (96, 'V for Vendetta', 'Thriller', NULL, NULL, 'Natalie Portman', 'James McTeigue');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (97, 'Memento', 'Crime', NULL, NULL, 'Guy Pearce', 'Christopher Nolan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (98, 'Gladiator', 'Action', NULL, NULL, 'Russell Crowe', 'Ridley Scott');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (99, 'Donnie Darko', 'Sci-Fi', NULL, NULL, 'Jake Gyllenhaal', 'Richard Kelly');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (100, 'Good Will Hunting', 'Drama', NULL, NULL, 'Matt Damon', 'Gus Van Sant');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (101, 'The Hangover', 'Comedy', NULL, NULL, 'Bradley Cooper', 'Todd Phillips');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (102, 'Gran Torino', 'Drama', NULL, NULL, 'Clint Eastwood', 'Clint Eastwood');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (103, 'The Butterfly Effect', 'Sci-Fi', NULL, NULL, 'Ashton Kutcher', 'Eric Bress');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (104, 'Sin City', 'Thriller', NULL, NULL, 'Jessica Alba', 'Robert Rodriguez');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (105, 'Snatch', 'Crime', NULL, NULL, 'Benicio Del Toro', 'Guy Ritchie');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (106, 'Robin Hood', 'Action', NULL, NULL, 'Russell Crowe', 'Ridley Scott');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (107, 'Beautiful Mind', 'Biography', NULL, NULL, 'Russell Crowe', 'Ron Howard');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (108, 'Juno', 'Romance', NULL, NULL, 'Ellen Page', 'Jason Reitman');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (109, 'Cinderella Man', 'Sport', NULL, NULL, 'Russell Crowe', 'Ron Howard');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (110, 'Meet Joe Black', 'Drama', NULL, NULL, 'Brad Pitt', 'Martin Brest');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (111, 'Planet Terror', 'Sci-Fi', NULL, NULL, 'Rose McGowan', 'Robert Rodriguez');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (112, 'Rocky', 'Sport', NULL, NULL, 'Sylvester Stallone', 'John G. Avildsen');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (113, 'Rocky II', 'Sport', NULL, NULL, 'Sylvester Stallone', 'Sylvester Stallone');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (114, 'Rocky III', 'Sport', NULL, NULL, 'Sylvester Stallone', 'Sylvester Stallone');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (115, 'Warrior', 'Sport', NULL, NULL, 'Tom Hardy', 'Gavin OConnor');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (116, '500 Days of Summer', 'Romance', NULL, NULL, 'Joseph Gordon-Levitt', 'Marc Webb');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (117, 'Sherlock Holmes', 'Mistery', NULL, NULL, 'Robert Downey Jr.', 'Guy Ritchie');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (118, 'Pulp Fiction', 'Crime', NULL, NULL, 'John Travolta', 'Quentin Tarantino');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (28, 'Zodiaco', 'Policial', 157, 6, 'Jake Gyllenhaal', 'David Fincher');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (29, 'Medianoche en Paris', 'Comedia', 100, 7, 'Rachel McAdams', 'Woody Allen');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (30, 'Match Point', 'Comedia', 124, 8, 'Scarlett Johansson', 'Woody Allen');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (119, 'Inglourious Basterds', 'War', NULL, NULL, 'Brad Pitt', 'Quentin Tarantino');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (120, 'Deathproof', 'Action', NULL, NULL, 'Kurt Russell', 'Quentin Tarantino');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (121, 'Fight Club', 'Thriller', NULL, NULL, 'Edward Norton', 'David Fincher');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (122, 'Batman Begins', 'Action', NULL, NULL, 'Christian Bale', 'Christopher Nolan');
      INSERT INTO pelicula (id_pelicula, nombre_pelicula, genero, duracion, calificacion, nombre_actor, nombre_director) VALUES (123, 'Shutter Island', 'Drama', NULL, NULL, 'Leonardo DiCaprio', 'Martin Scorsese');
YAML
ej4.language_id = language.id
ej4.guide_id = guide.id
ej4.hint = <<-MD
Solución

```sql
SELECT nacionalidad, count(*) AS cantidad
FROM pelicula p
LEFT JOIN director d ON p.nombre_director = d.nombre_director
WHERE nacionalidad is not null
GROUP BY nacionalidad
ORDER BY cantidad DESC
```
MD
ej4.extra = <<-SQL
CREATE TABLE actor(
  nombre VARCHAR(50) PRIMARY KEY,
  edad INT,
  anhos_activo INT
);
CREATE TABLE director(
  nombre_director VARCHAR(50) PRIMARY KEY,
  edad INT,
  nacionalidad VARCHAR(20),
  actor_fetiche VARCHAR(50), 
  CONSTRAINT fk_director_actor_fetiche FOREIGN KEY (actor_fetiche)
      REFERENCES actor(nombre) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE TABLE pelicula(
  id_pelicula integer PRIMARY KEY,
  nombre_pelicula VARCHAR(40), 
  genero VARCHAR(20),
  duracion INT, 
  calificacion INT, 
  nombre_actor VARCHAR(50),
  nombre_director VARCHAR(50) ,
  CONSTRAINT fk_pelicula_actor FOREIGN KEY (nombre_actor)
      REFERENCES actor(nombre) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_pelicula_director FOREIGN KEY (nombre_director)
      REFERENCES director(nombre_director) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
SQL
ej4.number = 4
ej4.corollary = 'Groso!'
ej4.extra_visible = true
ej4.save

