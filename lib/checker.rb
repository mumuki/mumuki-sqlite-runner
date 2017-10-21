module Sqlite
  class Checker < Mumukit::Metatest::Checker

    # Verify if solution dataset is equals than result
    # when equals: Return passed & render success
    # when distinct_columns: return failed & render error
    # when distinct_rows: return failed & render error
    def check(result, solution)
      name = I18n.t 'dataset', number: solution[:id]

      case solution[:dataset].compare result[:dataset]
        when :equals
          success(name, result)
        when :distinct_columns
          failed(name, result, solution, 'columns')
        when :distinct_rows
          failed(name, result, solution, 'rows')
        else
          failed(name, result, solution, 'query')
      end
    end

    def success(name, result)
      message = I18n.t 'message.success.query'
      [name, :passed, render_success(result, message)]
    end

    def failed(name, result, solution, error)
      error = I18n.t "message.failure.#{error}"
      [name, :failed, render_error(result, solution, error)]
    end

    # Return success page rendered with results
    def render_success(result, message)
      renderer.render_success result, message
    end

    # Return error page rendered with results & solutions
    def render_error(result, solution, error)
      renderer.render_error result, solution, error
    end

    private

    def renderer
      @renderer ||= Sqlite::HtmlRenderer.new
    end
  end
end
