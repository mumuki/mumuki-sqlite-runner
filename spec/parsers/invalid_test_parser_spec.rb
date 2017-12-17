
describe Sqlite::InvalidTestParser do

  let(:parser) do
    Sqlite::InvalidTestParser.new({
        type: 'query',
        seed: 'INSERT INTO ...',
        expected: 'SELECT * FROM ...'
    })
  end

  # test = {
  #   type: query,
  #   seed: INSERT INTO ...,
  #   expected: SELECT * FROM ...
  # }
  #
  # return {
  #   seed: -- NONE,
  #   expected: -- NONE
  # }
  describe '#parse' do
    it 'should override seed: and expected: with comments' do
      parse_expected = {
        seed: '-- NONE',
        expected: '-- NONE'
      }

      expect(parser.result).to eq parse_expected
    end

  end

  describe '#choose' do
    it 'should choose the solution given by argument' do
      expect(parser.choose('solution')).to eq 'solution'
    end
  end
end