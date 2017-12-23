
describe Sqlite::InvalidTestParser do
  let(:test) do {
      type: 'foo',
      seed: 'INSERT INTO ...',
      expected: 'SELECT * FROM ...'
    }.to_struct
  end

  describe '#parse' do
    it 'should raise error' do
      message = I18n.t('message.failure.tests.types', type: test.type)
      expect { Sqlite::InvalidTestParser.new test }.to raise_error(message)
    end
  end
end
