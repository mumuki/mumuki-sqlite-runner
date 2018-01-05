module Sqlite
  class FinalDatasetParser < DatasetsParser

    def initialize
      @fields = {
        required: [:type, :final, :expected],
        optional: [:seed]
      }
      @alias = {
          query: :final
      }
    end

    def show_query?
      true
    end

    def get_final_query
      has?(:final) ? get(:final) : get(:query)
    end

    protected

    def process_alias(keys)
      keys.map { |item| @alias.include?(item) ? @alias[item] : item }
    end

  end
end
