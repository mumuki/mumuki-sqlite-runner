# SQLite Worker based on Docker Container

This [mumuki/mumuki-sqlite-worker](https://hub.docker.com/r/mumuki/mumuki-sqlite-worker/)
is a container based on [tcgerlach/sqlite](https://hub.docker.com/r/tcgerlach/sqlite/).

It comes with `sqlite 3` and `python 2.7`. It was designed to use as engine 
of [mumuki/mumuki-sqlite-runner](https://github.com/mumuki/mumuki-sqlite-runner).

When receives a request from _Mumuki_ it executes `/bin/runsql file.json`.
 
As response, it sends **json data** to _stdout_ and **exit code** to _stderr_.

File is made by _sqlite runner_ after parse request from _Mumuki platform_.

### Input expected in _file.json_

```json
{
  "init":"CREATE TABLE test (\nid INTEGER PRIMARY KEY,\nname VARCHAR(200) NOT NULL\n);",
  "student":"SELECT * FROM test;",
  "tests":[
      {
        "seed":"INSERT INTO test (name) VALUES ('Test 1.1');\nINSERT INTO test (name) VALUES ('Test 1.2');\nINSERT INTO test (name) VALUES ('Test 1.3');",
        "expected":"SELECT name FROM test;"
      },
      {
        "seed":"INSERT INTO test (name) VALUES ('Test UTF-8 áéíóúñÁÉÍÓÚÑ');",
        "expected":"SELECT name FROM test;"
      },
      {
        "seed":"INSERT INTO test (name) VALUES ('Test UTF-8 áéíóúñÁÉÍÓÚÑ');",
        "expected":"-- NONE"
      }
  ]
}
```

### Output expected as _stdout_

```json
{
  "solutions": [
    "name\nTest 1.1\nTest 1.2\nTest 1.3", 
    "name\nTest UTF-8 áéíóúñÁÉÍÓÚÑ", 
    ""
  ], 
  "results": [
    "id|name\n1|Test 1.1\n2|Test 1.2\n3|Test 1.3", 
    "id|name\n1|Test UTF-8 áéíóúñÁÉÍÓÚÑ", 
    "id|name\n1|Test UTF-8 áéíóúñÁÉÍÓÚÑ"
  ]
}
```

where `solutions` are teacher's expected data and `results` are student's obtained.
