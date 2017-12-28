module Sqlite
  module GeneralParser

    COMMENT = '-- NONE'
    attr_reader :test_result

    def parse_test(test)
      @test = test
      @test_result = transform_test
    end

    # A Parser can choose it's own solution or just return which is passed.
    # This is default choice
    def choose_solution(solution)
      solution
    end

    def get_final_query
      ''
    end

    protected

    def transform_test
      {
          seed: get_seed,
          expected: get_expected
      }
    end

    def has?(key)
      !@test[key.to_sym].blank?
    end

    def get(key)
      @test[key.to_sym]
    end

    def get_seed
      has?(:seed) ? get(:seed).strip : ''
    end
  end
end
