
describe Sqlite::QueryTestParser do

  let(:parser) do
    Sqlite::QueryTestParser.new({
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
  #   seed: INSERT INTO ...,
  #   expected: SELECT * FROM ...
  # }
  describe '#parse' do
    it 'should extract seed: and expected: fields directly' do
      parse_expected = {
        seed: 'INSERT INTO ...',
        expected: 'SELECT * FROM ...'
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