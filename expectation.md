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
```

`post_process_file` expects result with this format:

```json
{
 "solutions": [
  "id|name|age\n1|Foo|10",
  "id|name|age\n1|Foo|10\n3|Bar|15"
 ],
 "results": [
  "id|name|age\n1|Foo|10",
  "id|name|age\n1|Foo|10\n4|Baz|17"
 ]
}
```