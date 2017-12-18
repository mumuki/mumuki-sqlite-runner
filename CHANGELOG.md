# version 3.0.0

 - Refactor dataset parsing when came from YAML in test.

# version 2.2.1
 
 - stable
 - Remove all docs/ folder because it only have documentation for my TIP but is not relevant to runner
 - Fixed encoding on docker container
 - Diff table results with colors (similar to git diff)
 - Fixed [duplicated code](https://github.com/leandrojdl/mumuki-sqlite-runner/issues/8)
 - [Internationalize messages](https://github.com/leandrojdl/mumuki-sqlite-runner/issues/2)
 - Mumuki Test now are Yaml instead of SQL code
 - Mumuki Test now could be datasets type or query type
 - Runner now allow to create non-select exercises (creates, inserts, updates, etc...); the only thing for now is that this type of exercises need to end with a select query. And the type of test need to be dataset.
 - **Important:** It is necessary to update docker container