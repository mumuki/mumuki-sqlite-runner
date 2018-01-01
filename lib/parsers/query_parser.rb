module Sqlite
  class QueryParser < BaseParser

    def initialize
      @fields = {
        required: [:type, :expected],
        optional: [:seed]
      }
    end

    protected

    def get_expected
      get(:expected).strip
    end
  end
end
