module Sqlite
  class QuerySolutionParser

    # Expected input:
    # OpenStruct#{
    #   solution_type: 'query',
    #   solution_query: 'select * from motores;',
    #   examples: [
    #     { dataset: "INSERT INTO ...\nINSERT INTO ..." }
    #   ]
    # }
    def parse_test(test)
      data = test.examples.map do |item|
        item[:data]
      end

      return test.solution_query, data
    end

    def choose(solution)
      solution
    end

  end
end
