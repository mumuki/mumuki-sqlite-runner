module Sqlite
  class Dataset
    attr_reader :header, :rows

    def initialize(data)
      @header = @rows = []
      rows = data.split(/\n+/i)
      unless rows.empty?
        @header = split_and_clean rows.shift
        @rows = rows.map { |item| split_and_clean item }
      end
    end

    def split_and_clean(rows)
      rows.split(/\|/).delete_if do |value|
        value.blank?
      end
    end

    def compare(other)
      same_header = same_header other.header
      same_rows   = same_rows other.rows

      if same_header & same_rows
        :equals
      elsif !same_header
        :distinct_columns
      else
        :distinct_rows
      end
    end

    protected

    def same_header(other_header)
      @header.eql? other_header
    end

    def same_rows(other_rows)
      same_amount(other_rows) && same_content(other_rows)
    end

    def same_amount(other_rows)
      @rows.length == other_rows.length
    end

    def same_content(other_rows)
      @rows.zip(other_rows).all? { |tuple| tuple[0] == tuple[1] }
    end

  end
end
