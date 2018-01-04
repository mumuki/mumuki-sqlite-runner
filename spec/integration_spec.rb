require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 2
  end

  after(:all) do
    Process.kill 'TERM', @pid
  end

  def self.load_exercise
    let(:exercise) do
      Sqlite::Exercise.get_struct(name)
    end
  end

  def self.run_with(solution_type)
    let(:response) do
      run_tests exercise.solution[solution_type],
                exercise.statement['test'],
                exercise.statement['extra']
    end
  end

  def self.run_program_as(solution_type, status, response_type)
    load_exercise
    run_with solution_type

    it "status: #{status}" do
      expect(response[:status]).to eq status
    end
    it "type: #{response_type}" do
      expect(response[:response_type]).to eq response_type
    end
  end

  def self.show_error_message(message)
    message = I18n.t message
    it "error: #{message}" do
      expect(response[:test_results][0][:result]).to include message
    end
  end

  shared_examples_for 'a successful submission' do
    run_program_as 'valid', :passed, :structured

    it 'process all tests' do
      expect(response[:test_results].size).to eq exercise.statement['count']
      response[:test_results].each.with_index do |test, i|
        expect(test[:title]).to eq I18n.t(:dataset, number: i + 1)
        expect(test[:result]).to include('<th>')
        expect(test[:result]).to include('<td>')
      end
    end
  end

  shared_examples_for 'a submission where columns do not match' do
    run_program_as 'column_error', :failed, :structured
    show_error_message 'message.failure.columns'
  end

  shared_examples_for 'a submission where rows do not match' do
    run_program_as 'row_error', :failed, :structured
    show_error_message 'message.failure.rows'
  end

  shared_examples_for 'a syntax-error submission' do
    run_program_as 'syntax_error', :failed, :unstructured

    it 'match syntax error message' do
      expect(response[:result]).to match exercise.solution['syntax_error_message']
    end
  end

  context 'Runner Test 1' do
    let(:name) { '00000_runner_test1' }
    it_behaves_like 'a successful submission'
    it_behaves_like 'a syntax-error submission'
  end

  context 'Runner Test 2' do
    let(:name) { '00000_runner_test2' }
    it_behaves_like 'a successful submission'
    it_behaves_like 'a syntax-error submission'
  end

  context 'Runner Test 3' do
    let(:name) { '00000_runner_test3' }
    it_behaves_like 'a successful submission'
    it_behaves_like 'a syntax-error submission'
  end

  context 'Runner Test 4' do
    let(:name) { '00000_runner_test4' }
    it_behaves_like 'a successful submission'
    it_behaves_like 'a syntax-error submission'
  end

  context 'Runner Test 5' do
    let(:name) { '00000_runner_test5' }
    it_behaves_like 'a successful submission'
  end

  context 'Prueba MQL' do
    let(:name) { '00001_prueba_mql' }
    it_behaves_like 'a successful submission'
  end

  context 'Hello SELECT!' do
    let(:name) { '00002_hello_select' }
    it_behaves_like 'a successful submission'
    it_behaves_like 'a submission where columns do not match'
    it_behaves_like 'a submission where rows do not match'
  end

  context 'Datasets Solutions' do
    let(:name) { '00003_datasets_solutions' }
    it_behaves_like 'a successful submission'
    it_behaves_like 'a submission where columns do not match'
    it_behaves_like 'a submission where rows do not match'
  end

  context 'Online Library' do
    let(:name) { '00004_online_library' }
    it_behaves_like 'a successful submission'
  end

  context 'Final Dataset 1' do
    let(:name) { '00005_final_dataset1' }
    it_behaves_like 'a successful submission'
  end

  context 'Final Dataset 2' do
    let(:name) { '00006_final_dataset2' }
    it_behaves_like 'a successful submission'
  end

  def run_tests(program, test, extra)
    bridge = Mumukit::Bridge::Runner.new('http://localhost:4568')
    bridge.run_tests! test: test.to_yaml,
                      extra: extra,
                      content: program,
                      expectations: []
  end

end
