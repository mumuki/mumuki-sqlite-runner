require 'pp'

class SqliteTestHook < Mumukit::Templates::FileHook

  isolated

  def tempfile_extension
    '.sql'
  end

  def command_line(filename)
    "runsql #{filename}"
  end

  def compile_file_content(request)
    <<~SQL
      -- CREATE
      #{request.creation}
      -- DATA
      #{request.data}
      -- QUERY
      #{request.content}
    SQL
  end

  def post_process_file(_file, result, status)
    output = result.strip
    [output, status]
  end

end
