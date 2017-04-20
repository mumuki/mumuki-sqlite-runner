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
        req = struct creation: 'create table test (num int);',
                     data: 'insert into test (42);',
                     content: 'select * from test;'
        expected_content = <<~SQL
          -- CREATE
          create table test (num int);
          -- DATA
          insert into test (42);
          -- QUERY
          select * from test;
        SQL

        expect(runner.compile_file_content(req)).to eq expected_content
      end
    end

    describe '#post_process_file("filename.sql", "-- sql code\\n", :passed)' do
      it do
        post_process = runner.post_process_file('filename.sql', "-- sql code\n", :passed)
        expect(post_process).to eq ['-- sql code', :passed]
      end
    end
  end

  describe 'parent methods' do
    describe '#run!' do

      context 'malformed queries' do
        Fixture.get(:syntax_error).each do | fixture |
          context "- with '#{fixture['query']}'" do
            let(:result) { run_fixture fixture }
            it "should fails with '#{fixture['expected_error']}'" do
              expect(result[1]).to eq :failed
              expect(result[0]).to match fixture['expected_error']
            end
          end
        end
      end

      context 'well-formed queries' do
        Fixture.get(:valid_queries).each do | fixture |
          context "- with: #{fixture['query']}" do
            let(:result) { run_fixture fixture }
            expected = fixture['expected_result']
            it "should passed and returns '#{Regexp.escape(expected.to_s)}" do
              expect(result[1]).to eq :passed
              expect(result[0]).to eq fixture['expected_result']
            end
          end
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
