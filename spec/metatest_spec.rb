describe 'metatest' do
  let(:result) { framework.test solutions, results }
  let(:framework) do
    Mumukit::Metatest::Framework.new checker: Sqlite::Checker.new,
                                     runner:  Sqlite::MultipleExecutionsRunner.new
  end
  let(:solutions) do
    [
      {
        id: 1,
        dataset: Sqlite::Dataset.new("name\nTest 1.1\nTest 1.2\nTest 1.3\n"),
      },{
        id: 2,
        dataset: Sqlite::Dataset.new("name\nTest 2.1\nTest 2.2\nTest 2.3\n"),
      }
    ]
  end

  describe 'result verification' do
    context 'wrong results' do
      let(:results) do
        [
          {
            id: 1,
            dataset: Sqlite::Dataset.new("id|name\n1|Test 1.1\n2|Test 1.2\n3|Test 1.3\n")
          },{
            id: 2,
            dataset: Sqlite::Dataset.new("id|name\n1|Test 2.1\n2|Test 2.2\n3|Test 2.3\n")
          }
        ]
      end

      it { expect(result[0][0][0]).to eq I18n.t :dataset, number: 1}
      it { expect(result[0][0][1]).to eq :failed }
      it { expect(result[0][0][2]).to include I18n.t 'failure.columns' }

      it { expect(result[0][1][0]).to eq I18n.t :dataset, number: 2 }
      it { expect(result[0][1][1]).to eq :failed }
      it { expect(result[0][1][2]).to include I18n.t 'failure.columns' }

    end

    context 'correct results' do
      let(:results) do
        [
          {
            id: 1,
            dataset: Sqlite::Dataset.new("name\nTest 1.1\nTest 1.2\nTest 1.3\n"),
          },{
            id: 2,
            dataset: Sqlite::Dataset.new("name\nTest 2.1\nTest 2.2\nTest 2.3\n"),
          },
        ]
      end

      it { expect(result[0][0][0]).to eq I18n.t :dataset, number: 1 }
      it { expect(result[0][0][1]).to eq :passed }
      it { expect(result[0][0][2]).to include I18n.t 'success.query' }

      it { expect(result[0][1][0]).to eq I18n.t :dataset, number: 2 }
      it { expect(result[0][1][1]).to eq :passed }
      it { expect(result[0][1][2]).to include I18n.t 'success.query' }
    end
  end
end
