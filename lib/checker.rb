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
          failed(name, result, solution, (I18n.t 'failure.columns'))
        when :distinct_rows
          failed(name, result, solution, (I18n.t 'failure.rows'))
        else
          failed(name, result, solution, (I18n.t 'failure.query'))
      end
    end

    def success(name, result)
      [name, :passed, render_success(result)]
    end

    def failed(name, result, solution, error)
      [name, :failed, render_error(result, solution, error)]
    end

    # Return success page rendered with results
    def render_success(result)
      renderer.render_success result
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
