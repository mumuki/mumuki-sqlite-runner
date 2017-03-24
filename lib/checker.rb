module Qsim
  class Checker < Mumukit::Metatest::Checker
    def check(result, example)
      @output_options = example[:output]
      super
    end

    def check_equal(result, records)
      records.each do |record, expected|
        actual = result[:records][record]
        fail I18n.t(:check_equal_failure, record: record, expected: expected, actual: actual) unless actual == expected
      end
    end

    def render_success_output(result)
      renderer.render(result, @output_options)
    end

    def render_error_output(result, error)
      "#{error}\n#{renderer.render(result, @output_options)}"
    end

    private

    def renderer
      @renderer ||= Qsim::HtmlRenderer.new
    end
  end
end
