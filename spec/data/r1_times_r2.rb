module Fixture
  def r1_times_r2_program
    <<~QSIM
      MUL R1, R2
    QSIM
  end

  def r1_times_r2_program_examples
    <<~EXAMPLE
      examples:
      - name: 'Times three stores the result in R1'
        preconditions:
         R1: '0002'
         R2: '0002'
        postconditions:
          equal:
            R1: '0004'
      - name: 'R2 remains unchanged'
        preconditions:
         R1: '0001'
         R2: '0003'
        postconditions:
          equal:
            R2: '0003'
    EXAMPLE
  end
end
