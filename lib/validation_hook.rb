class SqliteValidationHook < Mumukit::Hook

  include Sqlite::TestHelper

  def validate!(request)
    lint_tests request.test
    types_tests request.test
    fields_of_test_types request.test
  end

  def lint_tests(tests)
    begin
      YAML.load tests
    rescue
      fail! 'message.failure.tests.lint'
    end
  end

  def types_tests(tests)
    # Assumes pass lint_tests
    collect_tests(tests).each do |test|
      fail! 'message.failure.tests.type' if test.type.blank?
      fail!('message.failure.tests.types', type: test.type) unless parsers.has_key? test.type.to_sym
    end
  end

  def fields_of_test_types(tests)
    # Assumes pass types_tests
    collect_tests(tests).each do |test|
      parser = parsers[test.type.to_sym].new
      fail! "message.failure.tests.fields.#{test.type}" unless parser.test_has_valid_fields? test
    end
  end

  def fail!(*args)
    raise Mumukit::RequestValidationError, I18n.t(*args)
  end
end
