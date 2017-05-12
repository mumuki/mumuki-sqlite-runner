require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: ENV['LOG_PATH']  || '/dev/null'
    sleep 2
  end

  after(:all) do
    Process.kill 'TERM', @pid
  end

  shared_examples_for 'a successful submission' do |program, tests, extra = '', examples_count: 1|
    context 'answers a valid hash when submission passes' do
      let(:response) { run_tests(program, tests, extra) }

      it { expect(response[:response_type]).to eq :unstructured }
      it { expect(response[:test_results].size).to eq examples_count }
      it { expect(response[:status]).to eq :passed }
    end
    end

  shared_examples_for 'a syntax-error submission' do |program, tests, extra = '', examples_count: 1|
    context 'answers a failed hash when submission has syntax errors' do
      let(:response) { run_tests(program, tests, extra) }

      it { expect(response[:response_type]).to eq :unstructured }
      it { expect(response[:test_results].size).to eq examples_count }
      it { expect(response[:status]).to eq :failed }
    end
  end

  Fixture.get(:valid_queries).each_with_index do |fixture, index|
    context "given the ##{index+1} valid query example" do
      it_behaves_like 'a successful submission',
                      fixture['content'],
                      fixture['test'],
                      fixture['extra'],
                      examples_count: fixture['count']
    end
  end

  Fixture.get(:syntax_error).each_with_index do |fixture, index|
    context "given the ##{index+1} syntax-error example" do
      it_behaves_like 'a syntax-error submission',
                      fixture['content'],
                      fixture['test'],
                      fixture['extra'],
                      examples_count: 0
    end
  end

  def run_tests(program, tests, extra)
    bridge = Mumukit::Bridge::Runner.new('http://localhost:4568')
    bridge.run_tests!(test: tests, extra: extra, content: program, expectations: [])
  end

end
