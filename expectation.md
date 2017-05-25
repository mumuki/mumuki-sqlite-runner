```ruby
# in student code is not required opening tags
# in teacher's, instead, it is
#
# Important: tags must be like example below;
# If are different, script could not work as expected
#
# Is allowed:
#  - change blocks order between each request part
#  - case insensitive on tags (sql syntax is parsed by engine)
request = {
  test: '
    select ... from ...;
    -- DATASET
    insert into ...;
    insert into ...;
    ...
    -- DATASET
    insert into ...;
    insert into ...;
  ',
  extra: '
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
    -- #init
    #{request.extra.strip}
    -- #solution
    #{request.test.strip}
    -- #student
    #{request.content.strip}
  SQL
end

def post_process_file(_file, result, status)
  [process(result), status]
end

# expect string with this format
#
# -- #solutions # teacher query results
# -- SOLUTION 1
# id|name|age
#  1|Foo|10
# -- SOLUTION 2
# id|name|age
#  1|Foo|10
#  3|Bar|15
# -- #results  # student query results
# -- SOLUTION 1 # correct
# id|name|age
#  1|Foo|10
# -- SOLUTION 2 # wrong
# id|name|age
#  1|Foo|10
#  4|Baz|17
#
# return {
#  solutions: {
#   1: string SOLUTION 1,
#   2: string SOLUTION 2,
#   ...
#  },
#  results: {
#   1: string RESULT 1,
#   2: string RESULT 2,
#   ...
#  },
# }
def process(_result)
  # do the work ...
end

```
