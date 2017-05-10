##
# This Hook allow to run Sqlite Worker from an adhoc program that receives .sql files.

class SqliteTestHook < Mumukit::Templates::FileHook

  # Define that worker runs on a freshly-cleaned environment
  isolated

  # Just define file extension
  def tempfile_extension
    '.sql'
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
    <<~SQL
      #{request.extra.strip}
      -- SELECT-ALU
      #{request.content.strip}
    SQL
  end

  # Define how output results
  def post_process_file(_file, result, status)
    output = Sqlite::OutputProcessor.new result

    # FIXME do some better
    case status
      when :passed
        if output.select_alu.eql? output.select_doc
          ['OK', :passed]
        else
          ['La consulta no coincide', :errored]
        end
      when :failed
        [output.select_alu, status]
      else
        [output, status]
    end
  end

end
