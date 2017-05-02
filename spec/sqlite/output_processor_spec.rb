
describe Sqlite::OutputProcessor do

  let (:input) do
    <<~INPUT
      -- mql_create.sql
      -- mql_inserts.sql
      -- mql_select-doc.sql
      name
      Test 1
      Test 2
      -- mql_select-alu.sql
      name
      Test 3
      Test 4
    INPUT
  end

  let (:processor) do
    Sqlite::OutputProcessor.new input
  end

  it 'should get select-alu section' do
    expected = <<~EXPECTED
      name
      Test 3
      Test 4
    EXPECTED

    expect(processor.select_alu).to eq expected
  end
end