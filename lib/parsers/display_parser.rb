module Sqlite
  class DisplayParser
    include Sqlite::GeneralParser

    def initialize
      @fields = {
        required: [:type, :query],
        optional: [:seed]
      }
    end

    def get_final_query
      get(:query)
    end

    protected

    def get_expected
      get_final_query
    end
  end
end
