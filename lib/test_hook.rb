class QsimTestHook < Mumukit::Templates::FileHook
  include Mumukit::WithTempfile
  attr_reader :examples

  isolated

  def tempfile_extension
    '.qsim'
  end

  def command_line(filename)
    "runqsim #{filename} #{q_architecture} #{input_file_separator}"
  end

  def compile_file_content(request)
    test = parse_test(request)
    @examples = to_examples(test[:examples])
    @subject = test[:subject]

    Qsim::Subject
      .from_test(test, request)
      .compile_code(input_file_separator, initial_state_file)
  end

  def execute!(request)
    result, = run_file! compile request
    parse_json result
  end

  def post_process_file(_file, result, status)
    output = parse_json result

    case status
      when :passed
        framework.test output, @examples
      when :failed
        [output[:error], :errored]
      else
        [output, status]
    end
  end

  private

  def to_examples(examples)
    examples.each_with_index.map do |example, index|
      example[:preconditions] = classify(example.fetch(:preconditions, {}))
      example.merge(id: index, output: @output)
    end
  end

  def classify(fields)
    classified_fields = {}
    fields.each do |key, value|
      kind = category(key)
      unless kind == :unknown
        classified_fields.deep_merge!(kind => { key => value })
      end
    end
    classified_fields
  end

  def category(key)
    field = key.to_s
    return :records if record?(field)
    return :flags if flag?(field)
    return :memory if memory?(field)
    return :special_records if special_record?(field)
    :unknown
  end

  def record?(key)
    (0..7)
      .map { |number| "R#{number}" }
      .include?(key)
  end

  def flag?(key)
    %w(N C V Z).include? key
  end

  def memory?(key)
    /^[A-F0-9]{4}/.matches?(key)
  end

  def special_record?(key)
    %w(SP PC IR).include? key
  end

  def framework
    Mumukit::Metatest::Framework.new checker: Qsim::Checker.new,
                                     runner: Qsim::MultipleExecutionsRunner.new
  end

  def parse_json(json_result)
    JSON.parse(json_result).map(&:deep_symbolize_keys)
  end

  def parse_test(request)
    load_tests(request).tap do |tests|
      @output = define_output(tests)
    end
  end

  def load_tests(request)
    YAML.load(request.test).deep_symbolize_keys
  end

  def define_output(parsed_tests)
    output = { records: true }
    output.merge!(parsed_tests[:output] || {})
    check_memory_range(output) if output[:memory].is_a? Hash
    output.tap do |hash|
      hash
        .delete_if { |_, value| !value }
        .slice!(:records, :flags, :special_records, :memory)
    end
  end

  def check_memory_range(config)
    memory_settings = config[:memory]
    from = memory_settings[:from].to_hex
    to = memory_settings[:to].to_hex
    config[:memory] = false unless to > from && in_memory_range?(from, to)
  end

  def in_memory_range?(*addresses)
    addresses.all? { |address| memory_range.include?(address) }
  end

  def memory_range
    0..0xFFFF
  end

  def default_initial_state
    {
      special_records: {
        PC: '0000',
        SP: 'FFEF',
        IR: '0000'
      },
      flags: {
        N: 0,
        Z: 0,
        V: 0,
        C: 0
      },
      records: {
        R0: '0000',
        R1: '0000',
        R2: '0000',
        R3: '0000',
        R4: '0000',
        R5: '0000',
        R6: '0000',
        R7: '0000'
      },
      memory: {}
    }
  end

  def initial_state_file
    initial_states = @examples.map do |example|
      default_initial_state
        .merge(id: example[:id])
        .deep_merge(example[:preconditions])
    end
    JSON.generate(initial_states)
  end

  def q_architecture
    6
  end

  def input_file_separator
    '!!!BEGIN_EXAMPLES!!!'
  end
end
