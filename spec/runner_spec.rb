require 'json'

describe 'SqliteTestHook as isolated FileHook' do

  let(:runner) { SqliteTestHook.new }

  describe '#tempfile_extension' do
    it { expect(runner.tempfile_extension).to eq '.json' }
  end

  describe '#command_line "file.json"' do
    let(:command) { runner.command_line 'file.json'          }
    it            { expect(command).to eq 'runsql file.json' }
  end

  describe '#compile_file_content {extra, content, test}' do
    let(:req) do
      test = {
        solution_type: 'query',
        solution_query: 'select * from test',
        examples: [
          { 'data' => 'insert into test values (1)' },
          { 'data' => 'insert into test values (2)' },
          { 'data' => 'insert into test values (3)' },
          { 'data' => "insert into test values (4)\n-- more on same dataset\ninsert into test values (4.1)"
          }
        ]
      }.to_yaml

      struct extra: 'create table test',
             content: 'select id from test',
             test: test
    end

    it do
      expected = {
          init: 'create table test',
          solution: 'select * from test',
          student:  'select id from test',
          datasets: [
              'insert into test values (1)',
              'insert into test values (2)',
              'insert into test values (3)',
              "insert into test values (4)\n-- more on same dataset\ninsert into test values (4.1)"
          ],
      }.to_json

      expect(runner.compile_file_content(req)).to eq expected
    end
  end

  describe '#post_process_file' do
    it 'returns "OK" when query passed and match with expected' do
      result = {
        solutions: ['solution 1', 'solution 2'],
        results:   ['solution 1', 'solution 2']
      }

      post_process = runner.post_process_file('', result.to_json, :passed)

      expect(post_process[0][0][0]).to eq I18n.t :dataset, number: 1
      expect(post_process[0][0][1]).to eq :passed
      expect(post_process[0][0][2]).to include I18n.t 'success.query'

      expect(post_process[0][1][0]).to eq I18n.t :dataset, number: 2
      expect(post_process[0][1][1]).to eq :passed
      expect(post_process[0][1][2]).to include I18n.t 'success.query'
    end

    it "returns '#{I18n.t 'failure.columns'}' when query passed but not match with expected" do
      result = {
          solutions: ['solution 1', 'solution 2'],
          results:   ['solution 1', 'solution 3']
      }

      post_process = runner.post_process_file('', result.to_json, :passed)

      expect(post_process[0][1][0]).to eq I18n.t :dataset, number: 2
      expect(post_process[0][1][1]).to eq :failed
      expect(post_process[0][1][2]).to include I18n.t 'failure.columns'
    end

    it 'returns Error message when query fail' do
      result = {
          output: 'Error near something',
          code: 1
      }

      post_process = runner.post_process_file('', result.to_json, :failed)

      expect(post_process[1]).to eq :failed
      expect(post_process[0]).to eq 'Error near something'
    end
  end

  describe '#run!' do

    def self.load_exercise
      let(:exercise) do
        Sqlite::Exercise.get_struct(name)
      end
    end

    def self.run_with(query)
      let(:result) do
        run exercise.statement, exercise.solution[query]
      end
    end

    def self.run_exercise_as(query, status, message)
      load_exercise
      run_with query
      message = I18n.t message

      it "status: #{status}" do
        expect(result[0][0][1]).to eq status
      end

      it "message: '#{message}'" do
        expect(result[0][0][2]).to include message
      end
    end

    def self.run_syntax_error_exercise
      load_exercise
      run_with 'syntax_error'
      let(:error) { exercise.solution['syntax_error_message'] }
      status = :failed

      it "status: #{status}" do
        expect(result[1]).to eq status
      end

      it 'error: Syntax Error' do
        expect(result[0]).to match error
      end
    end

    shared_examples_for 'a solution that solves the exercise' do
      run_exercise_as 'valid', :passed, 'message.success.query'
    end

    shared_examples_for 'a solution with column error' do
      run_exercise_as 'column_error', :failed, 'message.failure.columns'
    end

    shared_examples_for 'a solution with row error' do
      run_exercise_as 'row_error', :failed, 'message.failure.rows'
    end

    shared_examples_for 'a solution with syntax error' do
      run_syntax_error_exercise
    end


    context 'Runner Test 1' do
      let(:name) { '00000_runner_test1' }
      it_behaves_like 'a solution that solves the exercise'
      it_behaves_like 'a solution with column error'
      it_behaves_like 'a solution with row error'
      it_behaves_like 'a solution with syntax error'
    end

    context 'Runner Test 2' do
      let(:name) { '00000_runner_test2' }
      it_behaves_like 'a solution that solves the exercise'
      it_behaves_like 'a solution with syntax error'
    end

    context 'Runner Test 3' do
      let(:name) { '00000_runner_test3' }
      it_behaves_like 'a solution that solves the exercise'
      it_behaves_like 'a solution with syntax error'
    end

    context 'Runner Test 4' do
      let(:name) { '00000_runner_test4' }
      it_behaves_like 'a solution that solves the exercise'
      it_behaves_like 'a solution with syntax error'
    end

    context 'Prueba MQL' do
      let(:name) { '00001_prueba_mql' }
      it_behaves_like 'a solution that solves the exercise'
    end

    context 'Datasets Solutions' do
      let(:name) { '00003_datasets_solutions' }
      it_behaves_like 'a solution that solves the exercise'
    end

    context 'Online Library' do
      let(:name) { '00004_online_library' }
      it_behaves_like 'a solution that solves the exercise'
    end


  end

  def run(exercise, query)
    req = struct extra: exercise['extra'],
                 content: query,
                 test: exercise['test'].to_yaml
    file = runner.compile req
    runner.run! file
  end

end
