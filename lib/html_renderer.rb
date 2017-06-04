require 'active_support/inflector'

module Sqlite
  class HtmlRenderer

    def render_success(result)
      @header = result[:dataset].header
      @rows   = result[:dataset].rows
      template_file_success.result binding
    end

    def render_error(result, solution, error)
      @error = error
      @result = {
          header: result[:dataset].header,
          rows: result[:dataset].rows
      }
      @solution = {
          header: solution[:dataset].header,
          rows: solution[:dataset].rows
      }
      template_file_error.result binding
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
