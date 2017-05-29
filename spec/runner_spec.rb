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

      test = <<~SQL
        select * from test
        --DATASET
        insert into test values (1)
        --    DATASET    
        insert into test values (2)
          --dataset
        insert into test values (3)
        --   dataset  
        
        insert into test values (4)
        -- more on same dataset
        insert into test values (4.1)
      SQL

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
      expect(post_process[0][0][2]).to include 'Consulta correcta!'

      expect(post_process[0][1][0]).to eq 'Dataset 2'
      expect(post_process[0][1][1]).to eq :passed
      expect(post_process[0][1][2]).to include 'Consulta correcta!'
    end

    it 'returns "La consulta no coincide" when query passed but not match with expected' do
      result = {
          solutions: ['solution 1', 'solution 2'],
          results:   ['solution 1', 'solution 3']
      }

      post_process = runner.post_process_file('', result.to_json, :passed)

      expect(post_process[0][1][0]).to eq 'Dataset 2'
      expect(post_process[0][1][1]).to eq :failed
      expect(post_process[0][1][2]).to include 'Las consultas no coinciden'
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

      context 'with malformed queries' do
        Fixture.get(:syntax_error).each do | fixture |
          context "'#{fixture['content']}'" do

            it "should fails with '#{fixture['expected']}'" do
              result = run_fixture fixture

              expect(result[1]).to eq :failed
              expect(result[0]).to match fixture['expected']
            end

          end
        end
      end

      context 'with well-formed queries' do
        Fixture.get(:valid_queries).each_with_index do | fixture, index |
          it "Test ##{index+1} should pass and returns OK" do
            result = run_fixture fixture

            expect(result[0][0][0]).to eq 'Dataset 1'
            expect(result[0][0][1]).to eq :passed
            expect(result[0][0][2]).to include 'Consulta correcta!'
          end
        end
      end

    end

  def run_fixture(fixture)
    req = struct extra: fixture['extra'],
                 content: fixture['content'],
                 test: fixture['test']
    file = runner.compile req
    runner.run! file
  end

end
