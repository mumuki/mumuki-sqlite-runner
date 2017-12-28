module Sqlite
  module TestHelper

    def set_test_parsers_hash
      @test_parsers = {
          query: Sqlite::QueryParser,
          display: Sqlite::DisplayParser,
          datasets: Sqlite::DatasetsParser,
          final_dataset: Sqlite::FinalDatasetParser,
      }
    end

    def load_tests(test)
      tests = YAML.load test
      tests = [tests] unless tests.kind_of? Array
      tests.map(&:to_struct)
    end

  end
end
