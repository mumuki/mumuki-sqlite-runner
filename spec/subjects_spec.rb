describe 'Subjects' do
  describe Qsim::Subject do
    describe '.from_test' do
      context 'given a subject' do
        it 'returns a Routine subject' do
          subject = subject_with_test(subject: 'bar')
          expect(subject).to be_instance_of Qsim::RoutineSubject
        end
      end

      context 'without subject' do
        it 'returns a Program subject' do
          subject = subject_with_test
          expect(subject).to be_instance_of Qsim::ProgramSubject
        end
      end

      def subject_with_test(test = {})
        Qsim::Subject.from_test(test, '')
      end
    end
  end

  describe '#compile_code' do
    context 'with a subject' do
      it 'returns the expected code' do
        code = compiled_code(Qsim::RoutineSubject, 'decrement')
        expect(code).to eq <<~QSIM
          JMP main

          NOP
          decrement: SUB AAAA, BBBB

          main:
          CALL decrement
          <<<>>>

        QSIM
      end
    end

    context 'without a subject' do
      it 'returns the expected code' do
        code = compiled_code(Qsim::ProgramSubject)
        expect(code).to eq <<~QSIM
          JMP main

          NOP

          main:
          MOV R0, R0
          decrement: SUB AAAA, BBBB
          <<<>>>

        QSIM
      end
    end

    def compiled_code(subject_class, subject = '')
      request = double('request', extra: 'NOP', content: 'decrement: SUB AAAA, BBBB')
      subject_class.new(subject, request).compile_code('<<<>>>', '')
    end
  end
end
