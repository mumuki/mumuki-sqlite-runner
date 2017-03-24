require_relative 'q1_ok_program'
require_relative 'r1_plus_r2_program'
require_relative 'times_two_program'
require_relative 'times_three_program'
require_relative 'r1_times_r2'

module Fixture
  def syntax_error_program
    'MOB R3, 0x0003'
  end

  def runtime_error_program
    'CALL unknown'
  end
end
