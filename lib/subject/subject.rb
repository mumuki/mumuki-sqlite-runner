module Qsim
  class Subject
    def self.from_test(test, request)
      subject = test[:subject]
      clazz = subject ? RoutineSubject : ProgramSubject
      clazz.new(subject, request)
    end

    def initialize(subject, request)
      @subject = subject
      @request = request
    end

    def compile_code(input_file_separator, initial_state_file)
      <<~QSIM
        JMP main

        #{extra_code}

        main:
        #{main_code}
        #{input_file_separator}
        #{initial_state_file}
      QSIM
    end
  end
end
