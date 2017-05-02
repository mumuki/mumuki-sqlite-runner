require 'pp'

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

    [output.select_alu, status]
  end

end
