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

