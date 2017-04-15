require 'yaml'
# require_relative 'q1_ok_program'
# require_relative 'r1_plus_r2_program'
# require_relative 'times_two_program'
# require_relative 'times_three_program'
# require_relative 'r1_times_r2'

class Fixture

  def self.get(fixture)
    load_file fixture
  end

  def self.load_file(name)
    YAML.load_file File.join(__dir__, "#{name.to_s}_fixture.yml")
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
