module Sqlite
  class QueryTestParser

    include Sqlite::CommonTestParser

    # test = {
    #   type: query,
    #   seed: INSERT INTO ...,
    #   expected: SELECT * FROM ...
    # }
    #
    # return {
    #   seed: INSERT INTO ...,
    #   expected: SELECT * FROM ...
    # }
    def parse(test)
      final_parse(test)
    end

  end
end
