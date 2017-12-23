module Sqlite
  class InvalidTestParser

    include Sqlite::CommonTestParser

    def parse(test)
      raise I18n.t('message.failure.tests.types', type: test.type)
    end
  end
end
