module Sqlite
  module CommonTestParser

    COMMENT = '-- NONE'
    attr_reader :result
    required :parse, 'You need to implement parse method when use CommonTestParse mixin!'

    def initialize(test)
      @result = parse test
    end

    def final_parse(test, override = {})
      seed = test[:seed].blank? ? '' : test[:seed].strip
      {
          seed:     override[:seed]     || seed,
          expected: override[:expected] || test[:expected].strip
      }
    end

    def choose(solution)
      solution
    end

  end
end
