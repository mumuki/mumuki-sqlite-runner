require 'yaml'

class Fixture

  def self.get(fixture)
    load_file fixture
  end

  def self.load_file(name)
    YAML.load_file File.join(__dir__, "#{name.to_s}_fixture.yml")
  end
end

module Sqlite
  class Exercise
    def self.get(name)
      YAML.load_file File.join(__dir__, "#{name.to_s}.yml")
    end
  end
end