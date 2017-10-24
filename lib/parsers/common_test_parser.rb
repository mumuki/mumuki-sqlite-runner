module Sqlite
  module CommonTestParser

    COMMENT = '-- NONE'
    attr_reader :result

    def initialize(test)
      @result = parse test
    end

    def final_parse(test, override = {})
      {
          seed:     override[:seed]     || test[:seed].strip,
          expected: override[:expected] || test[:expected].strip
      }
    end

    def choose(solution)
      solution
    end

  end
end
