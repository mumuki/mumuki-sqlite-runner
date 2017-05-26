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
    solution, datasets = parse_test request.test.strip

    content = {
        init: request.extra.strip,
        solution: solution,
        student: request.content.strip,
        datasets: datasets,

    }

    content.to_json
  end

  # Define how output results
  # param result expected:
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

    # FIXME do some better
    case status
      when :passed
        if output['results'] == output['solutions']
          ['OK', :passed]
        else
          ['La consulta no coincide', :errored]
        end
      when :failed
        [output['output'], status]
      else
        [output, status]
    end
  end

  # Split query by '-- DATASET' line match
  # First match is teacher solution
  # Rest are Datasets
  # Example:
  #   select * from table
  #   -- DATASET
  #   insert into 1
  #   -- dataset
  #   insert into 2
  def parse_test(content)
    query = content.split(/\s*--\s*DATASET\s*\n+/i)
    return query.shift, query
  end

end
