module Sqlite
  class DatasetSolutionParser

    # If solutions comes in an explicit datasets,
    # it was stored in instance variable.
    # Expected input:
    # OpenStruct#{
    #   solution_type: 'datasets',
    #   examples: [
    #     {
    #       dataset: "INSERT INTO ...\nINSERT INTO ...",
    #       solution_dataset: "id|field\n1|row1..."
    #     }
    #   ]
    # }
    def parse_test(test)
      data = []
      @solutions = []
      solution_query = '-- none'

      test.examples.each do |item|
        @solutions << item[:solution_dataset].scan(/(?!\|).+(?<!\|)/).join("\n")
        data.append item[:data]
      end

      return solution_query, data
    end

    def choose(_solution)
      @solutions
    end

  end
end
