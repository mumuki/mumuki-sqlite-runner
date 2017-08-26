require 'yaml'

module Sqlite
  class Exercise
    def self.get(name)
      YAML.load_file File.join(__dir__, "#{name.to_s}.yml")
    end
  end
end