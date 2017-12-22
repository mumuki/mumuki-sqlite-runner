module Sqlite
  class InvalidTestParser

    include Sqlite::CommonTestParser

    def parse(test)
      raise "Unsupported test type #{test.type}"
    end
  end
end
