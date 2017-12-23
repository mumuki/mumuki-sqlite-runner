class SqliteValidationHook < Mumukit::Hook

  include Sqlite::TestHelper

  def initialize(config = nil)
    super(config)
    set_test_parsers_hash
  end

  def validate!(request)
    lint_tests request.test
    types_tests request.test
  end

  def lint_tests(tests)
    begin
      YAML.load tests
    rescue
      raise Mumukit::RequestValidationError, I18n.t('message.failure.tests.lint')
    end
  end

  def types_tests(tests)
    # Assumes that pass lint_tests
    valid = load_tests(tests).all? do |test|
      @test_parsers.has_key? test.type.to_sym
    end
    raise Mumukit::RequestValidationError, I18n.t('message.failure.tests.types') unless valid
  end

end
