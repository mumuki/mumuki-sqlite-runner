
describe Sqlite::DatasetsParser do

  let(:solution) do
    <<-DATA.gsub(/\s+/, ' ').strip
      id|field
      1|row 1
      ...
    DATA
  end

  let(:parser) do
    Sqlite::DatasetsParser.new({
        type: 'dataset',
        seed: 'INSERT INTO ...',
        expected: solution
    })
  end

  # test = {
  #   type: dataset,
  #   seed: INSERT INTO ...,
  #   expected: |
  #     id|field
  #     1|row 1
  #     ...
  # }
  #
  # return {
  #   seed: INSERT INTO ...,
  #   expected: -- NONE
  # }
  describe '#parse' do
    it 'should extract seed: directly and override expected: with comment' do
      parse_expected = {
        seed: 'INSERT INTO ...',
        expected: '-- NONE'
      }

      expect(parser.result).to eq parse_expected
    end

  end

  describe '#choose' do
    it 'should choose the solution given in expected: field passed on init' do
      expect(parser.choose('solution')).to eq solution
    end
  end
end