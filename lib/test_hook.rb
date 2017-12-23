require 'json'
require 'diffy'

##
# This Hook allow to run Sqlite Worker from an ad-hoc program that receives .json files.

class SqliteTestHook < Mumukit::Templates::FileHook
  isolated
  include Sqlite::TestHelper

  def initialize(config = nil)
    super(config)
    set_test_parsers_hash
  end

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "runsql #{filename}"
  end

  # Transform Mumuki Request into Docker file style
  def compile_file_content(request)
    tests = parse_tests request.test
    final = get_final_query
    {
        init:    request.extra.strip,
        student: request.content.strip << final,
        tests:   tests
    }.to_json
  end

  # Transform Docker result into Response to Mumuki
  def post_process_file(_file, result, status)
    output = JSON.parse result
    case status
      when :passed
        expected, student = parse_output output
        framework.test expected, student
      when :failed
        [output['output'], status]
      else
        [output, status]
    end
  end

  protected

  def parse_output(output)
    student  = output['student']
    expected = output['expected']
    expected.map!.with_index do |expect, i|
      @tests[i].choose expect
    end
    diff(expected, student)
  end

  # Make diff between expected and student dataset result and mark each line one according comparision
  def diff(expected, student)
    zipped = expected.zip(student).map do |expected_i, student_i|
      diff = Diffy::SplitDiff.new student_i << "\n", expected_i << "\n"
      choose_left_right(diff, expected_i, student_i).map { |e| post_process_diff e }
    end
    zipped.transpose.map { |dataset| post_process_datasets dataset }
  end

  def choose_left_right(diff, expected, student)
    expected = diff.left  unless diff.left.blank?
    student  = diff.right unless diff.right.blank?
    [expected, student]
  end

  def post_process_diff(data)
    data.scan(/^(\s|-|\+)(.+)/)
        .map { |mark, content| mark << '|' << content }
        .join("\n")
  end

  # Transforms array datasets into hash with :id & :rows
  def post_process_datasets(datasets)
    datasets.map.with_index do |dataset, i|
      {
          id: i + 1,
          dataset: Sqlite::Dataset.new(dataset)
      }
    end
  end

  # This method receives a list of test cases and transforms each one according it parser
  def parse_tests(tests)
    @tests = load_tests(tests).map do | test |
      @test_parsers[test.type.to_sym].new test
    end
    @tests.map(&:result)
  end

  def get_final_query
    tests = @tests.select { |test| test.has_final? }
    tests.empty? ? '' : tests.first.get_final
  end

  # Initialize Metatest Framework with Checker & Runner
  def framework
    Mumukit::Metatest::Framework.new checker: Sqlite::Checker.new,
                                     runner: Sqlite::MultipleExecutionsRunner.new
  end

end
