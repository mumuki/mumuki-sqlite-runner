require 'mumukit/bridge'
require_relative '../lib/sqlite_runner'

def make_create
  <<~SQL
  CREATE TABLE test (
    id integer primary key,
    name varchar(200) NOT NULL
  );
  SQL
end

def make_program
  'select * from test;'
end

def make_test_for(number)
  <<~SQL
  #{make_program}
  -- DATASET
  #{make_inserts number}
  SQL
end

def make_inserts(number)
  (1..number).map do |n|
    "INSERT INTO test (name) values ('Value #{n}');"
  end.join("\n")
end

def time_for_data_amount(numbers)
  @pid = Process.spawn 'rackup -p 4568', err: ENV['LOG_PATH']  || '/dev/null'
  sleep 2

  times = (numbers).map do |number|
    extra = make_create
    tests = make_test_for(number)
    program = make_program

    diffs = (1..10).map do
      start = Time.now
      run_test_for_data_amount(tests, extra, program)
      Time.now - start
    end

    {number: number, time: (diffs.reduce(:+) / diffs.size.to_f)}
  end

  Process.kill 'TERM', @pid

  times
end

def run_test_for_data_amount(tests, extra, program)
  bridge = Mumukit::Bridge::Runner.new('http://localhost:4568')
  bridge.run_tests!(test: tests, extra: extra, content: program, expectations: [])
end


### Main script

numbers = ARGV[0] ? [ARGV[0].to_i] : [10, 100, 1000]

time_for_data_amount(numbers).each do |result|
  puts "Average Time with #{result[:number]} rows: #{result[:time].round(2)} seconds"
end