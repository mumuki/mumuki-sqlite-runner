module Sqlite
  class QueryParser
    include Sqlite::GeneralParser

    protected

    def get_expected
      get(:expected).strip
    end
  end
end
