require 'json'
require 'diffy'

##
# This Hook allow to run Sqlite Worker from an ad-hoc program that receives .json files.

class SqliteTestHook < Mumukit::Templates::FileHook

  # Define that worker runs on a freshly-cleaned environment
  isolated

  def initialize(config = nil)
    super(config)
    @test_parsers = {
        query:   Sqlite::QueryTestParser,
        dataset: Sqlite::DatasetTestParser
    }
    @test_parsers.default = Sqlite::InvalidTestParser
  end

  # Just define file extension
  def tempfile_extension
    '.json'
  end

  # Define the command to be run by sqlite worker
  def command_line(filename)
    "runsql #{filename}"
  end

  # Transform Mumuki Request into Docker file style
  # Request = {
  #   test: {
  #     type: (string) query|dataset,
  #     seed: (string) sql code to populate tables,
  #     expected: (string) query sentence | resulting table
  #   },
  #   extra: (string) sql code to create tables,
  #   content: (string) student's solution,
  #   expectations: []    # not using
  # }
  #
  def compile_file_content(request)
    {
        init:    request.extra.strip,
        student: request.content.strip,
        test:    parse_test(request.test)
    }.to_json
  end

  # Define how output results
  # Expected:
  # {
  #     "solutions": [
  #         "name\nTest 1.1\nTest 1.2\nTest 1.3\n",
  #         "name\nTest 2.1\nTest 2.2\nTest 2.3\n"
  #     ],
  #     "results": [
  #         "id|name\n1|Test 1.1\n2|Test 1.2\n3|Test 1.3\n",
  #         "id|name\n1|Test 2.1\n2|Test 2.2\n3|Test 2.3\n"
  #     ]
  # }
  def post_process_file(_file, result, status)
    output = JSON.parse(result)

    case status
      when :passed
        solutions, results = parse_output output
        framework.test solutions, results
      when :failed
        [output['output'], status]
      else
        [output, status]
    end
  end

  protected

  def parse_output(output)
    results   = output['results']
    solutions = output['solutions']
    unless @solution_parser.nil?
      solutions = @solution_parser.choose solutions
    end

    diff(solutions, results)
  end

  def diff(solutions, results)
    zipped = solutions.zip(results).map do |solution, result|

      diff = Diffy::SplitDiff.new result << "\n", solution << "\n"

      if diff.left.blank?
        [solution, result]
      else
        res = post_process_diff diff.left
        sol = post_process_diff diff.right
        [sol, res]
      end

    end

    zipped.transpose.map { |dataset| post_process_datasets dataset }
  end

  def post_process_diff(data)
    data.scan(/^(\s|-|\+)(.+)/)
        .map { |mark, content| mark << '|' << content }
        .join("\n")
  end

  # Transforms array datasets into hash with :id & :rows
  def post_process_datasets(datasets)
    datasets.map.with_index do |dataset, i|
      {
          id: i + 1,
          dataset: Sqlite::Dataset.new(dataset)
      }
    end
  end

  # This method receives a list of test cases.
  # Each one could be like one of these:
  #
  #   type: query
  #   seed: INSERT INTO ...
  #   expected: SELECT * FROM ...
  #
  #   type: dataset
  #   seed: INSERT INTO ...
  #   expected: |
  #     id|field
  #     1|row 1
  #     ...
  def parse_test(tests)
    @tests = tests.map do | test |
      test = YAML.load(test).deep_symbolize_keys.to_struct
      @test_parsers[test.type.to_sym].new test
    end

    @tests.map(&:result)
  end

  # Initialize Metatest Framework with Checker & Runner
  def framework
    Mumukit::Metatest::Framework.new checker: Sqlite::Checker.new,
                                     runner: Sqlite::MultipleExecutionsRunner.new
  end

end
