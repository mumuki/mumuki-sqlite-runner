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
        [name, :failed, render_error_output(result, solution, 'Las consultas no coinciden')]
      end

    end

    # Verify if both datasets are equals
    # Temp: comparing raw strings
    # Todo: convert into some struct and check headers, columns & rows
    def check_equal(result, solution)
      result == solution
    end

    # Return success page rendered with results
    def render_success_output(result)
      renderer.render_success result
      # "Consulta correcta!\n\n#{result[:rows]}"
    end

    # Return error page rendered with results & solutions
    def render_error_output(result, solution, error)
      renderer.render_error result, solution, error
      # "#{error}\n\nSe esperaba #{result[:rows]} pero se obtuvo #{solution[:rows]}"
    end

    private

    def renderer
      @renderer ||= Sqlite::HtmlRenderer.new
    end
  end
end
