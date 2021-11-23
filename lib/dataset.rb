module Sqlite
  class Dataset
    attr_reader :header, :rows

    def initialize(data)
      @header = @rows = []
      rows = split_lines data
      unless rows.empty?
        @header = split_pipe rows.shift
        @rows = rows.map { |item| split_pipe item }
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

    def split_lines(str)
      str.split(/\n+/i)
    end

    def split_pipe(line)
      line.split(/\|/)
    end

    def same_header(other_header)
      @header.map(&:downcase).eql? other_header.map(&:downcase)
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
