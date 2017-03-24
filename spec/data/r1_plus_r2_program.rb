module Fixture
  def r1_plus_r2_program
    <<~QSIM
      MOV R1, 0x0004
      CALL duplicateR1
    QSIM
  end

  def r1_plus_r2_program_extra
    <<~QSIM
      duplicateR1:
      MUL R1, 0x0002
      RET
    QSIM
  end

  def r1_plus_r2_program_examples
    <<~EXAMPLE
      examples:
      - name: 'R2 stores the sum of R0 and R1'
        preconditions:
          R0: 'B5E1'
          R1: '000F'
        postconditions:
          equal:
            R2: 'B5F0'
    EXAMPLE
  end
end
