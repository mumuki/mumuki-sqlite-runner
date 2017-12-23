require 'json'

describe 'ValidationTestHook' do

  let(:validator) { SqliteValidationHook.new }

  describe 'tests validations' do
    it 'should raise error when YAML is malformed' do
      tests = <<YAML
foo:---
bar
    type: final_dataset
    seed: |
      INSERT INTO bolitas (color) values ('Verde');
YAML

      expect { validate tests }.to raise_error(I18n.t('message.failure.tests.lint'))
    end

    it 'should raise error when at least one test type is not valid' do
      tests = <<YAML
- type: dataset # wrong --> correct is 'datasets'
- type: query   # valid
- type: final_dataset # correct
YAML
      expect { validate tests }.to raise_error(I18n.t('message.failure.tests.types'))
    end
  end

  def validate(tests, extra = '', content = '')
    request = struct extra: extra, content: content, test: tests
    validator.validate! request
  end

end
