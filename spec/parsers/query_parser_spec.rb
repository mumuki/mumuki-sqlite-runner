describe Sqlite::QueryParser do

  let(:parser) { Sqlite::QueryParser.new }
  let(:solution) { 'SELECT * FROM ...' }
  let(:test) do
    {
        type: 'query',
        seed: 'INSERT INTO ...',
        expected: solution
    }
  end

  describe '#parse_test' do
    # test = {
    #   seed: INSERT INTO ...,
    #   expected: SELECT * FROM ...
    # }
    #
    # return {
    #   seed: INSERT INTO ...,
    #   expected: SELECT * FROM ...
    # }
    it 'should keep seed and expected' do
      parse_expected = {
          seed: 'INSERT INTO ...',
          expected: 'SELECT * FROM ...'
      }
      parser.parse_test test
      expect(parser.test_result).to eq parse_expected
    end
  end

  describe '#choose_solution' do
    it 'should choose the solution passed by argument' do
      expect(parser.choose_solution('solution 1')).to eq 'solution 1'
      expect(parser.choose_solution('solution 2')).to eq 'solution 2'
    end
  end

  describe '#get_final_query' do
    it 'should return empty string' do
      expect(parser.get_final_query).to eq ''
    end
  end
end
