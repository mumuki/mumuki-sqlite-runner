
describe Sqlite::DatasetsParser do

  let(:parser) { Sqlite::DatasetsParser.new }
  let(:solution) do
    <<-DATA.gsub(/\s+/, ' ').strip
      id|field
      1|row 1
      ...
    DATA
  end
  let(:test) do
    {
        type: 'dataset',
        seed: 'INSERT INTO ...',
        expected: solution
    }
  end

  describe '#parse_test' do
    # test = {
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
    it 'should keep seed and override expected with comment' do
      parse_expected = {
        seed: 'INSERT INTO ...',
        expected: '-- NONE'
      }
      parser.parse_test test
      expect(parser.test_result).to eq parse_expected
    end
  end

  describe '#choose_solution' do
    it 'should choose the solution given in expected field' do
      parser.parse_test test
      expect(parser.choose_solution('solution ad-hoc')).to eq solution
    end
  end

  describe '#get_final_query' do
    it 'should return empty string' do
      expect(parser.get_final_query).to eq ''
    end
  end
end
