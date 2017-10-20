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

  shared_examples_for 'a successful submission' do |program, exercise, examples_count: 1|
    let(:response) { run_tests program, exercise['test'], exercise['extra'] }

    it { expect(response[:status]).to eq :passed }
    it { expect(response[:response_type]).to eq :structured }
    it { expect(response[:test_results].size).to eq examples_count }
  end

  shared_examples_for 'a submission where columns do not match' do |program, exercise|
    let(:response) { run_tests program, exercise['test'], exercise['extra'] }

    it { expect(response[:status]).to eq :failed }
    it { expect(response[:response_type]).to eq :structured }
    it { expect(response[:test_results][0][:result]).to include I18n.t 'failure.columns' }
  end

  shared_examples_for 'a submission where rows do not match' do |program, exercise|
    let(:response) { run_tests program, exercise['test'], exercise['extra'] }

    it { expect(response[:status]).to eq :failed }
    it { expect(response[:response_type]).to eq :structured }
    it { expect(response[:test_results][0][:result]).to include I18n.t 'failure.rows' }
  end

  shared_examples_for 'a syntax-error submission' do |program, exercise, error |
    let(:response) { run_tests program, exercise['test'], exercise['extra'] }

    it { expect(response[:status]).to eq :failed }
    it { expect(response[:response_type]).to eq :unstructured }
    it { expect(response[:result]).to match error }
  end

  context 'Runner Test 1' do
    exercise = Sqlite::Exercise.get('00000_runner_test1')

    program = 'select * from test1;'
    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']

    program = 'selec * from test1;'
    error = /Error: near line \d: near "selec": syntax error/
    it_behaves_like 'a syntax-error submission', program, exercise, error
  end

  context 'Runner Test 2' do
    exercise = Sqlite::Exercise.get('00000_runner_test2')

    program = 'select name from test2;'
    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']

    program = 'select from test2;'
    error = /Error: near line \d: near "from": syntax error/
    it_behaves_like 'a syntax-error submission', program, exercise, error
  end

  context 'Runner Test 3' do
    exercise = Sqlite::Exercise.get('00000_runner_test3')

    program = 'select name from test3;'
    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']

    program = 'select * fro test3;'
    error = /Error: near line \d: near "fro": syntax error/
    it_behaves_like 'a syntax-error submission', program, exercise, error
  end

  context 'Runner Test 4' do
    exercise = Sqlite::Exercise.get('00000_runner_test4')

    program = 'select name from test4 limit 0;'
    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']

    program = 'select * from test4'
    error = /Error: incomplete SQL: select \* from test4/
    it_behaves_like 'a syntax-error submission', program, exercise, error
  end

  context 'Prueba MQL' do
    exercise = Sqlite::Exercise.get('00001_prueba_mql')

    program = 'select * from motores;'
    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']
  end

  context 'Hello SELECT!' do
    exercise = Sqlite::Exercise.get('00002_hello_select')

    program = 'select * from bolitas;'
    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']

    program = 'select color from bolitas;'
    it_behaves_like 'a submission where columns do not match', program, exercise

    program = 'select * from bolitas limit 1;'
    it_behaves_like 'a submission where rows do not match', program, exercise
  end

  context 'Datasets Solutions' do
    exercise = Sqlite::Exercise.get('00003_datasets_solutions')

    program = 'select * from bolitas;'
    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']

    program = 'select color from bolitas;'
    it_behaves_like 'a submission where columns do not match', program, exercise

    program = 'select * from bolitas limit 1;'
    it_behaves_like 'a submission where rows do not match', program, exercise
  end

  context 'Online Library' do
    exercise = Sqlite::Exercise.get('00004_online_library')

    program = <<-SQL
      ALTER TABLE ejemplar ADD anio_edicion INT;
      SELECT * FROM ejemplar;
    SQL

    it_behaves_like 'a successful submission',
                    program, exercise, examples_count: exercise['count']
  end

  def run_tests(program, test, extra)
    bridge = Mumukit::Bridge::Runner.new('http://localhost:4568')
    bridge.run_tests! test: test.to_yaml,
                      extra: extra,
                      content: program,
                      expectations: []
  end

end
