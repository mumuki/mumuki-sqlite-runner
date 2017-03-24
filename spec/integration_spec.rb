require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  extend Fixture

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end

  after(:all) { Process.kill 'TERM', @pid }

  shared_examples_for 'a successful submission' do |program, tests, extra = '', examples_count: 1|
    context 'answers a valid hash when submission passes' do
      let(:response) { run_tests(program, tests, extra) }

      it { expect(response[:response_type]).to eq :structured }
      it { expect(response[:test_results].size).to eq examples_count }
      it { expect(response[:status]).to eq :passed }
    end

    def run_tests(program, tests, extra)
      bridge = Mumukit::Bridge::Runner.new('http://localhost:4568')
      bridge.run_tests!(test: tests, extra: extra, content: program, expectations: [])
    end
  end

  context 'given a single example' do
    it_behaves_like 'a successful submission', q1_ok_program, q1_ok_program_examples
  end

  context 'given multiples examples' do
    it_behaves_like 'a successful submission',
                    r1_times_r2_program,
                    r1_times_r2_program_examples,
                    examples_count: 2
  end

  context 'given a subject' do
    it_behaves_like 'a successful submission',
                    times_three_program,
                    times_three_program_examples
  end

  context 'given extra code' do
    it_behaves_like 'a successful submission',
                    times_two_program,
                    times_two_program_examples,
                    times_two_program_extra
  end
end
