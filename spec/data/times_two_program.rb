module Fixture
  def times_two_program
    <<~QSIM
      MOV R1, 0x0002
      CALL timesTwo
      CALL timesTwo
    QSIM
  end

  def times_two_program_extra
    <<~QSIM
      timesTwo:
        MUL R1, 0x0002
      RET
    QSIM
  end

  def times_two_program_examples
    <<~EXAMPLE
      examples:
      - name: 'R1 is 0008'
        preconditions:
         {}
        postconditions:
          equal:
            R1: '0008'
    EXAMPLE
  end
end
