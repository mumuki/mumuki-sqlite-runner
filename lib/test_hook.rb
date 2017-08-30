require 'json'
require 'diffy'

##
# This Hook allow to run Sqlite Worker from an ad-hoc program that receives .json files.

class SqliteTestHook < Mumukit::Templates::FileHook

  # Define that worker runs on a freshly-cleaned environment
  isolated

  # Just define file extension
  def tempfile_extension
    '.json'
  end

  # Define the command to be run by sqlite worker
  def command_line(filename)
    "runsql #{filename}"
  end

  # Define the .json file template from request structure
  # Input: request = {
  #   test: (yaml string) teacher's code that define which testing verification student code should pass,
  #   extra: (sql string) teacher's code that prepare field where student code should run,
  #   content: (sql string) student code,
  #   expectations: [] not using for now
  # }
  #
  def compile_file_content(request)
    solution, data = parse_test request.test

    content = {
        init: request.extra.strip,
        solution: solution,
        student: request.content.strip,
        datasets: data
    }

    content.to_json
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

  # Test should have one of these formats:
  #
  # Solution by query:
  # { solution_type: 'query',
  #   solution_query: 'SELECT * FROM ...',
  #   examples: [
  #     { data: "INSERT INTO..." }
  #   ]
  # }
  #
  # Solution by datasets:
  # { solution_type: 'datasets',
  #   examples: [
  #     { data: "INSERT INTO...",
  #       solution: "id|field\n1|row1..."
  #     }
  #   ]
  # }
  def parse_test(test)
    test = OpenStruct.new YAML.load(test).deep_symbolize_keys

    case test.solution_type.to_sym
      when :query
        @solution_parser = Sqlite::QuerySolutionParser.new
      when :datasets
        @solution_parser = Sqlite::DatasetSolutionParser.new
      else
        raise Sqlite::TestSolutionTypeError
    end

    @solution_parser.parse_test test
  end

  # Initialize Metatest Framework with Checker & Runner
  def framework
    Mumukit::Metatest::Framework.new checker: Sqlite::Checker.new,
                                     runner: Sqlite::MultipleExecutionsRunner.new
  end

end
