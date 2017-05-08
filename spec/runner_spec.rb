require 'pp'
require_relative 'data/fixture'

describe SqliteTestHook do

  let(:runner) { SqliteTestHook.new }

  describe 'redefined methods' do

    describe '#tempfile_extension' do
      it { expect(runner.tempfile_extension).to eq '.sql' }
    end

    describe '#command_line("filename.sql")' do
      it do
        command = runner.command_line('filename.sql')
        expect(command).to eq 'runsql filename.sql'
      end
    end

    describe '#compile_file_content' do
      it 'should build valid sql syntax from a valid request received' do
        extra = <<~SQL
          -- CREATE
          create table test (num int);
          -- INSERTS
          insert into test (42);
          -- SELECT-DOC
          select num from test;
        SQL

        req = struct content: 'select * from test;',
                     extra: extra,
                     test: ''
        expected_content = <<~SQL
          -- CREATE
          create table test (num int);
          -- INSERTS
          insert into test (42);
          -- SELECT-DOC
          select num from test;
          -- SELECT-ALU
          select * from test;
        SQL

        expect(runner.compile_file_content(req)).to eq expected_content
      end
    end

    describe '#post_process_file' do
      it 'returns "OK" when query passed and match with expected' do
        result = <<~OUTPUT
          -- mql_create.sql
          -- mql_inserts.sql
          -- mql_select-doc.sql
          name
          Test 1
          Test 2
          Test 3
          -- mql_select-alu.sql
          name
          Test 1
          Test 2
          Test 3
        OUTPUT

        post_process = runner.post_process_file('', result, :passed)

        expect(post_process[1]).to eq :passed
        expect(post_process[0]).to eq 'OK'
      end

      it 'returns "La consulta no coincide" when query passed but not match with expected' do
        result = <<~OUTPUT
          -- mql_create.sql
          -- mql_inserts.sql
          -- mql_select-doc.sql
          name
          Test 1
          Test 2
          Test 3
          -- mql_select-alu.sql
          name
          Test 1
          Test 2
        OUTPUT

        post_process = runner.post_process_file('', result, :passed)

        expect(post_process[1]).to eq :errored
        expect(post_process[0]).to eq 'La consulta no coincide'
      end

      it 'returns Error message when query fail' do
        result = <<~OUTPUT
          -- mql_create.sql
          -- mql_inserts.sql
          -- mql_select-doc.sql
          -- mql_select-alu.sql
          Error near something
        OUTPUT

        post_process = runner.post_process_file('', result, :failed)

        expect(post_process[1]).to eq :failed
        expect(post_process[0]).to eq 'Error near something'
      end
    end
  end

  describe 'parent methods' do
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
            expect(result[1]).to eq :passed
            expect(result[0]).to eq 'OK'
          end
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
