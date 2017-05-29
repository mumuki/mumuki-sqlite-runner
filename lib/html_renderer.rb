require 'active_support/inflector'

module Sqlite
  class HtmlRenderer

    def render_success(result)
      @dataset = result[:id]
      @headers, @rows = split_rows(result[:rows])
      template_file_success.result binding
    end

    def render_error(result, solution, error)
      @error = error
      @dataset = result[:id]
      @result_headers, @result_rows = split_rows(result[:rows])
      @solution_headers, @solution_rows = split_rows(solution[:rows])
      template_file_error.result binding
    end

    def split_rows(result)
      rows = result.split(/\n+/i)
      headers = rows.shift.split(/\|/)
      rows = rows.map { |row| row.split(/\|/) }
      return headers, rows
    end

    protected

    def template_file_success
      ERB.new File.read("#{__dir__}/view/rows_success.html.erb")
    end

    def template_file_error
      ERB.new File.read("#{__dir__}/view/rows_error.html.erb")
    end

  end
end
