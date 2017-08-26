require 'json'

##
# This Hook allow to run Sqlite Worker from an adhoc program that receives .sql files.

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

  # Define the .sql file template from request structure
  # request = {
  #   test: (string) teacher's code that define which testing verification student code should pass,
  #   extra: (string) teacher's code that prepare field where student code should run,
  #   content: (string) student code,
  #   expectations: [mulang verifications] todo: better explain
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
        results   = post_process_datasets(output['results'])
        solutions = post_process_datasets(choose_solutions output['solutions'])
        framework.test solutions, results
      when :failed
        [output['output'], status]
      else
        [output, status]
    end
  end

  def choose_solutions(output_solutions)
    case @solution_type
      when :datasets
        @output_solutions
      else
        output_solutions
    end
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
    test = OpenStruct.new (YAML.load(test).deep_symbolize_keys)
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
    @output_solutions = []
    solution_query = '-- none'

    test.examples.each do |item|
      @output_solutions.append item[:solution_dataset].strip
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
