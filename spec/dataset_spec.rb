
describe Sqlite::Dataset do

  let(:solution) do
    rows = <<~ROWS
      id|name
      1|Name 1
      2|Name 2
      3|Name 3
    ROWS
    Sqlite::Dataset.new rows
  end

  describe '#compare' do
    # :equals
    it 'should be equals when has same columns & same rows in same order' do
      result = <<~ROWS
        id|name
        1|Name 1
        2|Name 2
        3|Name 3
      ROWS
      result = Sqlite::Dataset.new result

      expect(solution.compare result).to eq :equals
    end

    # :distinct_columns
    it 'should has distinct columns when result has less columns than solution' do
      result = <<~ROWS
        name
        Name 1
        Name 2
        Name 3
      ROWS
      result = Sqlite::Dataset.new result

      expect(solution.compare result).to eq :distinct_columns
    end

    # :distinct_columns
    it 'should has distinct columns when result has more columns than solution' do
      result = <<~ROWS
        id|name|none
        1|Name 1|A
        2|Name 2|B
        3|Name 3|C
      ROWS
      result = Sqlite::Dataset.new result

      expect(solution.compare result).to eq :distinct_columns
    end

    # :distinct_rows
    it 'should has distinct rows when result has same columns but has more rows than solution' do
      result = <<~ROWS
        id|name
        1|Name 1
        2|Name 2
        3|Name 3
        4|Name 4
      ROWS
      result = Sqlite::Dataset.new result

      expect(solution.compare result).to eq :distinct_rows
    end

    # :distinct_rows
    it 'should has distinct rows when result has same columns but has less rows than solution' do
      result = <<~ROWS
        id|name
        1|Name 1
        3|Name 3
      ROWS
      result = Sqlite::Dataset.new result

      expect(solution.compare result).to eq :distinct_rows
    end

    # :distinct_rows
    it 'should has distinct rows when result has same columns and same amount of rows but different content' do
      result = <<~ROWS
          id|name
          1|Name 1
          2|Name 3
          3|Name 2
        ROWS
      result = Sqlite::Dataset.new result

      expect(solution.compare result).to eq :distinct_rows
    end

  end

end
