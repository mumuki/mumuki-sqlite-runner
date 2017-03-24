module Qsim
  class ProgramSubject < Subject
    def extra_code
      @request.extra
    end

    def main_code
      "#{skip_command}\n#{@request.content}"
    end

    def skip_command
      'MOV R0, R0'
    end
  end
end
