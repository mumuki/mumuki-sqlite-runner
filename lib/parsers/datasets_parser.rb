module Sqlite
  class DatasetsParser

    include Sqlite::GeneralParser

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
      final_parse test, {expected: '-- NONE'}
    end

    def choose(_solution)
      @solutions
    end

  end
end
