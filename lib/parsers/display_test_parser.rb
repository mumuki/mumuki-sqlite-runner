module Sqlite
  class DisplayTestParser
    include Sqlite::CommonTestParser

    def has_final?
      has?(:query)
    end

    def get_final
      # Assume has_final? is true
      get(:query)
    end

    def parse(test)
      final_parse test, { expected: get_final }
    end
  end
end
