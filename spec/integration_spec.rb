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

  shared_examples_for 'a successful submission' do |program, test, extra = '', examples_count: 1|
    let(:response) { run_tests program, test, extra }

    it { expect(response[:status]).to eq :passed }
    it { expect(response[:response_type]).to eq :structured }
    it { expect(response[:test_results].size).to eq examples_count }
  end

  context 'Runner Test 1' do
    exercise = Sqlite::Exercise.get('00000_runner_test1')

    program = 'select * from test1;'
    it_behaves_like 'a successful submission',
                    program,
                    exercise['test'],
                    exercise['extra'],
                    examples_count: 1

    # query = 'selec * from test1;'
    # error = /Error: near line \d: near "selec": syntax error/
    # it_behaves_like 'an invalid query', exercise, query, error
  end

  # shared_examples_for 'a syntax-error submission' do |program, tests, extra = '', examples_count: 1|
  #   context 'answers a failed hash when submission has syntax errors' do
  #     let(:response) { run_tests(program, tests, extra) }
  #
  #     it { expect(response[:status]).to eq :failed }
  #     it { expect(response[:response_type]).to eq :unstructured }
  #     it { expect(response[:test_results].size).to eq examples_count }
  #   end
  # end
  #
  # Fixture.get(:valid_queries).each_with_index do |fixture, index|
  #   context "given the ##{index+1} valid query example" do
  #     it_behaves_like 'a successful submission',
  #                     fixture['content'],
  #                     fixture['test'],
  #                     fixture['extra'],
  #                     examples_count: fixture['count']
  #   end
  # end
  #
  # Fixture.get(:syntax_error).each_with_index do |fixture, index|
  #   context "given the ##{index+1} syntax-error example" do
  #     it_behaves_like 'a syntax-error submission',
  #                     fixture['content'],
  #                     fixture['test'],
  #                     fixture['extra'],
  #                     examples_count: 0
  #   end
  # end

  def run_tests(program, test, extra)
    bridge = Mumukit::Bridge::Runner.new('http://localhost:4568')
    bridge.run_tests! test: test.to_yaml,
                      extra: extra,
                      content: program,
                      expectations: []
  end

end
