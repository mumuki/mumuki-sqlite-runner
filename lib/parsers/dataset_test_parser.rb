module Sqlite
  class DatasetTestParser

    def initialize(test)
      @test = test
      @result = parse test
    end

    # test = {
    #   type: dataset,
    #   seed: INSERT INTO ...,
    #   expected: |
    #     id|field
    #     1|row 1
    #     ...
    # }
    #
    # return {
    #   seed: INSERT INTO ...,
    #   expected: -- NONE
    # }
    def parse(test)
      @solutions = test[:expected].to_s.split("\n").map(&:strip).join("\n")
      final_parse test, {espected: '-- NONE'}
    end

    def choose(_solution)
      @solutions
    end

  end
end
