module Sqlite
  module CommonTestParser

    COMMENT = '-- NONE'
    attr_reader :result, :final
    required :parse, 'You need to implement parse method when use CommonTestParse mixin!'

    def initialize(test)
      @test = test
      @result = parse test
    end

    def choose(solution)
      solution
    end

    def has?(key)
      !@test[key.to_sym].blank?
    end

    def get(key)
      @test[key.to_sym]
    end

    def has_final?
      # Only FinalDataset should have final query
      false
    end

    def get_final
      ''
    end

    protected

    def final_parse(test, override = {})
      seed = test[:seed].blank? ? '' : test[:seed].strip
      {
          seed:     override[:seed]     || seed,
          expected: override[:expected] || test[:expected].strip
      }
    end

  end
end
