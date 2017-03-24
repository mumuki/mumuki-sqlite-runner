module Fixture
  def times_three_program
    <<~QSIM
      timesThree:
      MUL R1, 0x0003
      RET
    QSIM
  end

  def times_three_program_examples
    <<~EXAMPLE
      subject: 'timesThree'
      examples:
      - name: 'Times three stores the result in R1'
        preconditions:
         R1: '0002'
        postconditions:
          equal:
            R1: '0006'
    EXAMPLE
  end
end
