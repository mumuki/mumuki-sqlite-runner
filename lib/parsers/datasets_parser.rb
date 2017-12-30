module Sqlite
  class DatasetsParser
    include Sqlite::GeneralParser

    def initialize
      @fields = {
          required: [:type, :expected],
          optional: [:seed]
      }
    end

    def choose_solution(_solution)
      @solutions
    end

    protected

    def transform_test
      @solutions = strip_lines get(:expected)
      super
    end

    def get_expected
      COMMENT
    end

    def strip_lines(array)
      array.to_s
          .split("\n")
          .map(&:strip)
          .join("\n")
    end
  end
end
