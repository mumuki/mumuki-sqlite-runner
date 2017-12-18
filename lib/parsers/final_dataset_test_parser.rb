module Sqlite
  class FinalDatasetTestParser < DatasetTestParser

    def initialize(test)
      super(test)
      @final = test[:query] || test[:final]
    end

  end
end
