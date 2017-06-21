module Sqlite
  class TestSolutionTypeError < StandardError
    def initialize(msg = 'Yaml Test must have solution_type with one of these values: query or datasets')
      super
    end
  end
end
