module Sqlite
  class FinalDatasetParser < DatasetsParser
    def get_final_query
      has?(:final) ? get(:final) : get(:query)
    end
  end
end
