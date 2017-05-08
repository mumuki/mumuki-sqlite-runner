```ruby
# in student code is not required opening tags
# in teacher's, instead, it is
#
# Is important to use tags with this explicit name with these freedoms
#  - order
#  - case insensitive
request = {
  test: '
    -- SOLUTION
    select ... from ...;
    -- DATASET-TEST-1
    insert into ...;
    insert into ...;
    ...
    -- DATASET-TEST-n
    insert into ...;
    insert into ...;
  ',
  extra: '
    -- CREATE
    create table ...;
    insert into ...;
    # any sql sentences needed to prepare field
  ',
  content: '
    select ... from ...;
    # potentially could be possible to execute inserts, updates or any other
    # sql sentences, but (for now at least) it should be necessary to end
    # content program with an <select> query to be able to verify results.
  ',
  expectations: [
    'mulang verification 1',
    'mulang verification 2',
    '# not used for now'
  ]
}

def compile_file_content(request)
  <<~SQL
    -- [init]
    #{request.extra.strip}
    -- [tests]
    #{request.test.strip}
    -- [student]
    #{request.content.strip}
  SQL
end

def post_process_file(_file, result, status)
  [process(result), status]
end

# expect string with this format
#
# -- [solutions] # teacher query results
# -- SOLUTION-1
# id|name|age
#  1|Foo|10
# -- SOLUTION-2
# id|name|age
#  1|Foo|10
#  3|Bar|15
# -- [results]  # student query results
# -- SOLUTION-1 # correct
# id|name|age
#  1|Foo|10
# -- SOLUTION-2 # wrong
# id|name|age
#  1|Foo|10
#  4|Baz|17
#
# return {
#  solutions: [string SOLUTION-1, string SOLUTION-2, ..],
#  results: [string RESULT-1, string RESULT-2, ..],
# }
def process(_result)
  # do the work ...
end

```
