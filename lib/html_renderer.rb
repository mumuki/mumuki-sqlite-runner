require 'active_support/inflector'

module Sqlite
  class HtmlRenderer

    def render_success(result, message)
      @message = message
      @table_name = result[:table_name]
      @header  = result[:dataset].header
      @rows    = result[:dataset].rows
      @extra_message = extra_message result
      template_file_success.result binding
    end

    def render_error(result, solution, error)
      @error = error
      @table_name = result[:table_name]
      @result = parse_dataset(result[:dataset].header, result[:dataset].rows)
      @solution = parse_dataset(solution[:dataset].header, solution[:dataset].rows)
      @expected_message = expected_message result
      @obtained_message = I18n.t 'obtained'
      template_file_error.result binding
    end

    protected

    def parse_dataset(header, rows)
      header_sign = header.shift
      rows = rows.map do |row|
        {
            sign: row.shift,
            row: row
        }
      end

      {
          header: {
              sign: header_sign,
              class: diff_class_of(header_sign),
              fields: header
          },
          rows: rows.map do |row|
            {
                sign:row[:sign],
                class: diff_class_of(row[:sign]),
                fields: row[:row]
            }
          end
      }

    end

    def diff_class_of(value)
      case value
        when '+'
          'required'
        when '-'
          'errored'
        else
          'nothing'
      end
    end

    def extra_message(result)
      result[:show_query] ? I18n.t('message.success.show_query', query: result[:query]) : ''
    end

    def expected_message(result)
      if result[:show_query]
        I18n.t('message.failure.show_query', query: result[:query])
      else
        I18n.t 'expected'
      end
    end

    def template_file_success
      ERB.new File.read("#{__dir__}/view/rows_success.html.erb")
    end

    def template_file_error
      ERB.new File.read("#{__dir__}/view/rows_error.html.erb")
    end

  end
end
