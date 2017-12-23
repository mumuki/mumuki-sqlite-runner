module Sqlite
  module TestHelper

    def set_test_parsers_hash
      @test_parsers = {
          query: Sqlite::QueryTestParser,
          datasets: Sqlite::DatasetTestParser,
          final_dataset: Sqlite::FinalDatasetTestParser,
      }
      @test_parsers.default = Sqlite::InvalidTestParser
    end

    def load_tests(test)
      tests = YAML.load test
      tests = [tests] unless tests.kind_of? Array
      tests.map(&:to_struct)
    end

  end
end
