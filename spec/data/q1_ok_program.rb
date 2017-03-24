module Fixture
  def q1_ok_program
    <<~QSIM
      MOV R3, 0x0003
      MOV R5, 0x0004
      ADD R3, R5
    QSIM
  end

  def q1_ok_program_examples
    <<~EXAMPLE
      examples:
      - name: 'R3 is 0007'
        preconditions:
         {}
        postconditions:
          equal:
            R3: '0007'
    EXAMPLE
  end
end
