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
      it 'output result set when query passed and match with expected' do
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

        output_expected = <<~DATASET
          name
          Test 1
          Test 2
          Test 3
        DATASET

        post_process = runner.post_process_file('filename.sql', result, :passed)

        expect(post_process[1]).to eq :passed
        expect(post_process[0]).to eq output_expected
      end
    end
  end

  describe 'parent methods' do
    # describe '#run!' do
    #
    #   context 'malformed queries' do
    #     Fixture.get(:syntax_error).each do | fixture |
    #       context "- with '#{fixture['query']}'" do
    #         let(:result) { run_fixture fixture }
    #         it "should fails with '#{fixture['expected_error']}'" do
    #           expect(result[1]).to eq :failed
    #           expect(result[0]).to match fixture['expected_error']
    #         end
    #       end
    #     end
    #   end
    #
    #   context 'well-formed queries' do
    #     Fixture.get(:valid_queries).each do | fixture |
    #       context "- with: #{fixture['query']}" do
    #         let(:result) { run_fixture fixture }
    #         expected = fixture['expected_result']
    #         it "should passed and returns '#{Regexp.escape(expected.to_s)}" do
    #           expect(result[1]).to eq :passed
    #           expect(result[0]).to eq fixture['expected_result']
    #         end
    #       end
    #     end
    #   end
    #
    # end
  end

  def run_fixture(fixture)
    req = struct content: fixture['query'],
                 creation: fixture['creation'],
                 data: fixture['data']
    file = runner.compile(req)
    runner.run! file
  end

end
