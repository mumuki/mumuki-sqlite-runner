module Sqlite
  class OutputProcessor

    # Initialize with result:string
    #
    # Expected format:
    #
    # -- mql_create.sql
    # [empty || error message]
    # -- mql_inserts.sql
    # [empty || error message]
    # -- mql_select-doc.sql
    # [dataset || error message]
    # -- mql_select-alu.sql
    # [dataset || error message]
    def initialize(result)

      @data = {
          trash: '',
          create: '',
          inserts: '',
          'select-doc': '',
          'select-alu': '',
      }

      current = 'trash'
      result.to_s.each_line do |line|
        if tag? line
          current = extract_name line
        else
          @data = @data.merge({current => line}) { |_, old, new| old << new }
        end
      end

    end

    # Returns output corresponding to the student query
    def select_alu
      @data['select-alu'.to_sym]
    end

    protected

    def tag?(line)
      line.to_s.start_with? '-- mql_'
    end

    def extract_name(line)
      line.to_s.gsub(/-- mql_/, '').gsub(/.sql/, '').strip.to_sym
    end

  end
end