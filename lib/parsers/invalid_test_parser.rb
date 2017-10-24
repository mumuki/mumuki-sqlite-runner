module Sqlite
  class InvalidTestParser

    include Sqlite::CommonTestParser

    def parse(test)
      final_parse(test, {
          seed: COMMENT,
          expected: COMMENT
      })
    end

  end
end
