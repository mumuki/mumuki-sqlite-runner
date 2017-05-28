module Sqlite
  class Checker < Mumukit::Metatest::Checker

    # Verify if example dataset is equals than result
    # if ok: Return passed & render success if ok
    # else : return failed & render error
    def check(result, solution)
      name = "Dataset #{solution[:id]}"
      @solution = solution[:rows]

      if check_equal(result[:rows], solution[:rows])
        [name, :passed, render_success_output(result)]
      else
        [name, :failed, render_error_output(result, 'Las consultas no coinciden')]
      end

    end

    # Verify if both datasets are equals
    # Temp: comparing raw strings
    # Todo: convert into some struct and check headers, columns & rows
    def check_equal(result, solution)
      result == solution
    end

    # Return success message to be printed
    # Include row table
    # Todo: call HtmlRenderer
    def render_success_output(result)
      # renderer.render(result, @output_options)
      "Consulta correcta!\n\n#{result[:rows]}"
    end

    # Return error message to be printed
    # Include result rows & solution rows to show differences
    # Todo: call HtmlRenderer
    def render_error_output(result, error)
      # "#{error}\n#{renderer.render(result, @output_options)}"
      "#{error}\n\nSe esperaba #{result[:rows]} pero se obtuvo #{@solution}"
    end

    private

    def renderer
      @renderer ||= Sqlite::HtmlRenderer.new
    end
  end
end
