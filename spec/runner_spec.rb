require 'pp'
require_relative 'data/fixture'

describe SqliteTestHook do

  let(:runner) { SqliteTestHook.new }

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

  describe '#run!' do

    context 'program fails with this syntax errors:' do
      Fixture.get(:syntax_error).each do | fixture |
        it "- #{fixture['name']}: #{fixture['query']}" do
          result = run_fixture fixture

          expect(result[1]).to eq :failed
          expect(result[0]).to match fixture['expected_error']
        end
      end
    end

    context 'program obtain valid records with this queries:' do
      Fixture.get(:valid_queries).each do | fixture |
        it "- #{fixture['name']}: #{fixture['query']}" do
          result = run_fixture fixture

          expect(result[1]).to eq :passed
          expect(result[0]).to eq fixture['expected_result']
        end
      end
    end

  end

  def run_fixture(fixture)
    req = struct content: fixture['query'],
                 creation: fixture['creation'],
                 data: fixture['data']
    file = runner.compile(req)
    runner.run! file
  end

end
