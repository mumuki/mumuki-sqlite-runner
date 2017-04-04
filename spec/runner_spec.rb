require_relative '../spec/data/fixture'

describe QsimTestHook do
  include Fixture

  let(:runner) { QsimTestHook.new }

  # describe '#set_output' do
  #   let(:defaults) { { records: true } }
  #
  #   context 'when specified' do
  #     it 'removes unnecessary keys' do
  #       output = build_output(foo: 1)
  #       expect(output).to eq defaults
  #     end
  #
  #     it 'keeps specified settings and adds defaults' do
  #       output = build_output(flags: true, special_records: true, memory: true)
  #       expect(output).to eq recordsx: true,
  #                            flags: true,
  #                            special_records: true,
  #                            memory: true
  #     end
  #
  #     context 'given a memory range' do
  #       context 'when out of range' do
  #         it 'sets memory to false' do
  #           output = build_output(memory: { from: '0', to: 'FFFF0' })
  #           expect(output).to eq defaults
  #         end
  #       end
  #
  #       context "when 'from' is greater 'than' to" do
  #         it 'sets memory to false' do
  #           output = build_output(memory: { from: '2', to: '1' })
  #           expect(output).to eq defaults
  #         end
  #       end
  #
  #       it 'remains unchanged' do
  #         output = build_output(memory: { from: '0', to: 'AAAA' })
  #         expect(output[:memory]).to eq from: '0', to: 'AAAA'
  #       end
  #     end
  #   end
  #
  #   context 'when it is not specified' do
  #     it 'sets default values' do
  #       output = build_output
  #       expect(output).to eq defaults
  #     end
  #   end
  #
  #   def build_output(config = {})
  #     test = (config.empty? ? {} : { output: config })
  #     runner.send(:define_output, test)
  #   end
  # end
  #
  # describe '#to_examples' do
  #   it 'categorizes preconditions records and fields' do
  #     tests = [{ preconditions: { R1: '1010', N: '1', PC: '1', FFFF: '1' } }]
  #     example = to_examples(tests).first
  #     expect(example).to eq id: 0,
  #                           preconditions: {
  #                             records: { R1: '1010' },
  #                             special_records: { PC: '1' },
  #                             flags: { N: '1' },
  #                             memory: { FFFF: '1' }
  #                           }
  #   end
  #
  #   it 'accepts tests without preconditions' do
  #     example = to_examples([{}]).first
  #     expect(example).to eq id: 0,
  #                           preconditions: {}
  #   end
  #
  #   it 'ignores unmatched preconditions' do
  #     tests = [preconditions: { foo: '1', R8: '1', Z: '1' }]
  #     example = to_examples(tests).first
  #     expect(example).to eq id: 0,
  #                           preconditions: { flags: { Z: '1' } }
  #   end
  #
  #   def to_examples(tests)
  #     runner.send(:to_examples, tests).map { |test| test.except(:output) }
  #   end
  # end
  #
  # describe '#compile_file_content' do
  #   let(:request) do
  #     req(r1_plus_r2_program, r1_plus_r2_program_extra, r1_plus_r2_program_examples)
  #   end
  #   let(:compilation) { runner.compile_file_content(request) }
  #   let(:example) do
  #     runner.compile_file_content(request)
  #     runner.examples.first
  #   end
  #
  #   it 'compiles the code and preconditions' do
  #     expect(compilation).to eq <<~QSIM
  #       JMP main
  #
  #       duplicateR1:
  #       MUL R1, 0x0002
  #       RET
  #
  #       main:
  #       MOV R0, R0
  #       MOV R1, 0x0004
  #       CALL duplicateR1
  #       !!!BEGIN_EXAMPLES!!!
  #       [{"special_records":{"PC":"0000","SP":"FFEF","IR":"0000"},"flags":{"N":0,"Z":0,"V":0,"C":0},"records":{"R0":"B5E1","R1":"000F","R2":"0000","R3":"0000","R4":"0000","R5":"0000","R6":"0000","R7":"0000"},"memory":{},"id":0}]
  #     QSIM
  #   end
  #
  #   it 'parses the examples' do
  #     expect(example).to eq id: 0,
  #                           name: 'R2 stores the sum of R0 and R1',
  #                           preconditions: {
  #                             records: { R0: 'B5E1', R1: '000F' }
  #                           },
  #                           postconditions: {
  #                             equal: { R2: 'B5F0' }
  #                           },
  #                           output: { records: true }
  #   end
  # end
  #
  # describe '#execute!' do
  #   let(:result) do
  #     request = req(q1_ok_program)
  #     runner.execute!(request).first
  #   end
  #
  #   it 'returns qsim execution result' do
  #     expect(result).to include id: 0,
  #                               special_records: { PC: '0008', SP: 'FFEF', IR: '28E5 ' },
  #                               flags: { N: 0, Z: 0, V: 0, C: 0 },
  #                               records: {
  #                                 R0: '0000', R1: '0000', R2: '0000', R3: '0007',
  #                                 R4: '0000', R5: '0004', R6: '0000', R7: '0000'
  #                               }
  #   end
  # end

  # arrancar por aca
  # buscar gem que permita comparar facil cosas de sql
  describe '#run!' do
    context 'when program fails with syntax error' do
      let(:result) { run!('selec * from test;') }

      it { expect(result[1]).to eq :errored }
      it { expect(result[0]).to eq "Error: near line 2: near \"selec\": syntax error\n" }
    end

    # context 'when program fails with runtime error' do
    #   let(:result) { run!(runtime_error_program) }
    #
    #   it { expect(result[1]).to eq :errored }
    #   it { expect(result[0]).to eq 'Una de las etiquetas utilizadas es invalida' }
    # end

    # context 'when program finishes' do
    #   context 'when it is successful' do
    #     let(:result) { result_expecting(R3: '0007') }
    #
    #     it { expect(result[0]).to eq 'R3 is 0007' }
    #     it { expect(result[1]).to eq :passed }
    #   end
    #
    #   context 'when it fails' do
    #     let(:result) { result_expecting(R3: '0008') }
    #
    #     it { expect(result[0]).to eq 'R3 is 0007' }
    #     it { expect(result[1]).to eq :failed }
    #   end
    #
    #   def result_expecting(record)
    #     examples = [{ name: 'R3 is 0007',
    #                   operation: :run,
    #                   postconditions: { equal: record } }]
    #     run!(q1_ok_program, examples).first.first
    #   end
    # end

    def run!(program, examples = [{}])
      tests = { examples: examples }.to_yaml
      request = req(program, '', tests)
      file = runner.compile(request)
      runner.run!(file)
    end
  end

  def req(content, extra = '', test = 'examples: [{}]')
    struct content: content.strip, extra: extra.strip, test: test
  end
end
