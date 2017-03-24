require 'active_support/inflector'

module Qsim
  class HtmlRenderer
    def render(result, output)
      @output = output
      @result = {}
      output.keys.each do |output_key|
        fields = range(output_key, output)
                   .map { |key| [key_for(output_key, key), '0000'] }
                   .to_h
                   .merge(result[output_key])
                   .sort
        @result[output_key] = fields
      end
      template_file.result binding
    end

    private

    def template_file
      ERB.new File.read("#{__dir__}/view/records.html.erb")
    end

    def to_memory(number)
      number.to_s(16).rjust(4, '0').upcase.to_sym
    end

    def to_record(number)
      "R#{number}".to_sym
    end

    def to_flag(number)
      number.to_sym
    end

    def to_special_record(record)
      record.to_sym
    end

    def memory_range(options)
      from = options[:memory][:from].to_hex
      to = options[:memory][:to].to_hex
      (from..to)
    end

    def range(output_key, output)
      send("#{output_key}_range", output)
    end

    def key_for(output_key, key)
      send("to_#{output_key}".singularize, key)
    end

    def records_range(_)
      (0..7)
    end

    def flags_range(_)
      %w(N Z V C).map(&:to_sym)
    end

    def special_records_range(_)
      %w(SP PC IR).map(&:to_sym)
    end
  end
end
