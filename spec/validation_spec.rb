require 'json'

describe 'ValidationTestHook' do

  let(:validator) { SqliteValidationHook.new }

  shared_examples_for 'invalid fields' do |type, incomplete, unsupported|
    let(:message) { I18n.t "message.failure.tests.fields.#{type}" }
    it 'should raise error if does not have expected field' do
      expect { validate incomplete }.to raise_error(message)
    end
    it 'should raise error if have unsupported fields' do
      expect { validate unsupported }.to raise_error(message)
    end
  end

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

    it 'should raise error if does not have `type` field' do
      tests = <<YAML
- foo: bar
- type: baz
YAML
      message = I18n.t('message.failure.tests.type')
      expect { validate tests }.to raise_error(message)
    end

    it 'should raise error when at least one `type` is not valid' do
      tests = <<YAML
- type: dataset # wrong --> correct is 'datasets'
- type: query   # valid
- type: final_dataset # correct
YAML
      message = I18n.t('message.failure.tests.types', type: 'dataset')
      expect { validate tests }.to raise_error(message)
    end

    context 'type `datasets` validation' do
      type = 'datasets'
      incomplete = <<YAML
type: #{type}
seed: insert into foo values ('bar');
YAML
      unsupported = <<YAML
type: #{type}
expected: data
seed: insert into foo values ('bar');
other: not supported
YAML
      it_behaves_like 'invalid fields', type, incomplete, unsupported
    end

    context 'type `query` validation' do
      type = 'query'
      incomplete = <<YAML
type: #{type}
seed: insert into foo values ('bar');
YAML
      unsupported = <<YAML
type: #{type}
expected: a query
foo: not supported
YAML
      it_behaves_like 'invalid fields', type, incomplete, unsupported
    end

    context 'type `final_dataset` validation' do
      type = 'final_dataset'
      incomplete = <<YAML
type: #{type}
expected: foo
seed: insert into foo values ('bar');
YAML
      unsupported = <<YAML
type: #{type}
expected: data
final: query
foo: not supported
YAML
      it_behaves_like 'invalid fields', type, incomplete, unsupported
    end

    context 'type `display` validation' do
      type = 'display'
      incomplete = <<YAML
type: #{type}
YAML
      unsupported = <<YAML
type: #{type}
seed: data
query: query
foo: not supported
YAML
      it_behaves_like 'invalid fields', type, incomplete, unsupported
    end

  end

  def validate(tests, extra = '', content = '')
    request = struct extra: extra, content: content, test: tests
    validator.validate! request
  end

end
