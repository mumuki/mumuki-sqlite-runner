module Sqlite
  class InvalidTestParser

    include Sqlite::CommonTestParser

    # return {
    #   seed: -- NONE,
    #   expected: -- NONE
    # }
    def parse(test)
      final_parse(test, {
          seed: COMMENT,
          expected: COMMENT
      })
    end

  end
end
