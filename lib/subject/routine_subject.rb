module Sqlite
  class RoutineSubject < Subject
    def extra_code
      "#{@request.extra}\n#{@request.content}"
    end

    def main_code
      "CALL #{@subject}"
    end
  end
end
