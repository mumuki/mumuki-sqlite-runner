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

      expect(post_process[0][0][0]).to eq 'Dataset 1'
      expect(post_process[0][0][1]).to eq :passed
      expect(post_process[0][0][2]).to include I18n.t :correct_query

      expect(post_process[0][1][0]).to eq 'Dataset 2'
      expect(post_process[0][1][1]).to eq :passed
      expect(post_process[0][1][2]).to include I18n.t :correct_query
    end

    it 'returns "Las columnas no coincide" when query passed but not match with expected' do
      result = {
          solutions: ['solution 1', 'solution 2'],
          results:   ['solution 1', 'solution 3']
      }

      post_process = runner.post_process_file('', result.to_json, :passed)

      expect(post_process[0][1][0]).to eq 'Dataset 2'
      expect(post_process[0][1][1]).to eq :failed
      expect(post_process[0][1][2]).to include 'Las columnas no coinciden'
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

    shared_examples_for 'a correct query' do |exercise, query|
      let(:result) { run exercise, query }

      it { expect(result[0][0][1]).to eq :passed }
      it { expect(result[0][0][2]).to include I18n.t :correct_query }
    end

    shared_examples_for 'a query with different columns' do |exercise, query|
      let(:result) { run exercise, query }

      it { expect(result[0][0][1]).to eq :failed }
      it { expect(result[0][0][2]).to include 'Las columnas no coinciden' }
    end

    shared_examples_for 'a query with different rows' do |exercise, query|
      let(:result) { run exercise, query }

      it { expect(result[0][0][1]).to eq :failed }
      it { expect(result[0][0][2]).to include 'Las filas no coinciden' }
    end

    shared_examples_for 'an invalid query' do |exercise, query, error|
      let(:result) { run exercise, query }
      it { expect(result[1]).to eq :failed }
      it { expect(result[0]).to match error }
    end

    context 'Runner Test 1' do
      exercise = Sqlite::Exercise.get('00000_runner_test1')

      query = 'select * from test1;'
      it_behaves_like 'a correct query', exercise, query

      query = 'select name from test1;'
      it_behaves_like 'a query with different columns', exercise, query

      query = 'select * from test1 limit 1;'
      it_behaves_like 'a query with different rows', exercise, query

      query = 'selec * from test1;'
      error = /Error: near line \d: near "selec": syntax error/
      it_behaves_like 'an invalid query', exercise, query, error
    end

    context 'Runner Test 2' do
      exercise = Sqlite::Exercise.get('00000_runner_test2')

      query = 'select name from test2;'
      it_behaves_like 'a correct query', exercise, query

      query = 'select from test2;'
      error = /Error: near line \d: near "from": syntax error/
      it_behaves_like 'an invalid query', exercise, query, error
    end

    context 'Runner Test 3' do
      exercise = Sqlite::Exercise.get('00000_runner_test3')

      query = 'select name from test3;'
      it_behaves_like 'a correct query', exercise, query

      query = 'select * fro test3;'
      error = /Error: near line \d: near "fro": syntax error/
      it_behaves_like 'an invalid query', exercise, query, error
    end

    context 'Runner Test 4' do
      exercise = Sqlite::Exercise.get('00000_runner_test4')

      query = 'select name from test4 limit 0;'
      it_behaves_like 'a correct query', exercise, query

      query = 'select * from test4'
      error = /Error: incomplete SQL: select \* from test4/
      it_behaves_like 'an invalid query', exercise, query, error
    end

    context 'Prueba MQL' do
      exercise = Sqlite::Exercise.get('00001_prueba_mql')

      query = 'select * from motores;'
      it_behaves_like 'a correct query', exercise, query
    end

    context 'Datasets Solutions' do
      exercise = Sqlite::Exercise.get('00003_datasets_solutions')

      query = 'select * from bolitas;'
      it_behaves_like 'a correct query', exercise, query
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
