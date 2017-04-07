require_relative 'q1_ok_program'
require_relative 'r1_plus_r2_program'
require_relative 'times_two_program'
require_relative 'times_three_program'
require_relative 'r1_times_r2'

module Fixture
  def runtime_error_program
    'CALL unknown'
  end
end

module InvalidSyntax
  def self.query
    'selec * from test;'
  end

  def self.expected_status
    :errored
  end

  def self.expected_message
    <<~ERROR
      Error: near line 2: near "selec": syntax error
    ERROR
  end
end

module TestTable
  module SelectAll
    def self.query
      'select * from test;'
    end

    def self.expected_status
      :passed
    end

    def self.expected_message
      <<~RESULT
        id|name
        1|Testing1
        2|Testing2
        3|Testing3
      RESULT
    end
  end
end
