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
        results   = output['results']
        solutions = choose_solutions output['solutions']
        solutions, results = diff solutions, results

        framework.test solutions, results
      when :failed
        [output['output'], status]
      else
        [output, status]
    end
  end

  protected

  # If solutions comes in an explicit datasets, it was stored in
  # a instance variable of this class.
  # Instead if solution is correct query, it is passed to the worken
  # and dataset solution comes from worker.
  def choose_solutions(output_solutions)
    case @solution_type
      when :datasets
        @solutions
      else
        output_solutions
    end
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
    test = OpenStruct.new (yaml_load test)
    @solution_type = test.solution_type.to_sym

    case @solution_type
      when :query
        parse_test_as_query_solution test
      when :datasets
        parse_test_as_datasets_solution test
      else
        raise Sqlite::TestSolutionTypeError
    end
  end

  # Load input as yaml with deepness
  def yaml_load(test)
    (YAML.load test).deep_symbolize_keys
  end

  # Expected input:
  # OpenStruct#{
  #   solution_type: 'query',
  #   solution_query: 'select * from motores;',
  #   examples: [
  #     { dataset: "INSERT INTO ...\nINSERT INTO ..." }
  #   ]
  # }
  def parse_test_as_query_solution(test)
    data = test.examples.map do |item|
      item[:data]
    end

    return test.solution_query, data
  end

  # Expected input:
  # OpenStruct#{
  #   solution_type: 'datasets',
  #   examples: [
  #     {
  #       dataset: "INSERT INTO ...\nINSERT INTO ...",
  #       solution_dataset: "id|field\n1|row1..."
  #     }
  #   ]
  # }
  def parse_test_as_datasets_solution(test)
    data = []
    @solutions = []
    solution_query = '-- none'

    test.examples.each do |item|
      @solutions << item[:solution_dataset].scan(/(?!\|).+(?<!\|)/).join("\n")
      data.append item[:data]
    end

    return solution_query, data
  end

  # Initialize Metatest Framework with Checker & Runner
  def framework
    Mumukit::Metatest::Framework.new checker: Sqlite::Checker.new,
                                     runner: Sqlite::MultipleExecutionsRunner.new
  end

end
