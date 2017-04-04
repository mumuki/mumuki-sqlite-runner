module Qsim
  class ProgramSubject < Subject
    def extra_code
      @request.extra
    end

    def main_code
      "#{@request.content}"
    end

  end
end
