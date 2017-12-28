module Sqlite
  class FinalDatasetParser < DatasetsParser

    def has_final?
      has?(:final) || has?(:query)
    end

    def get_final
      # Assume has_final? is true
      has?(:final) ? get(:final) : get(:query)
    end

  end
end
