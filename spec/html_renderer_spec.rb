
describe Sqlite::HtmlRenderer do

  let(:renderer) { Sqlite::HtmlRenderer.new }

  describe '#split_rows' do
    it 'should split rows into a header-array and rows-array' do
      headers, rows = renderer.split_rows("id|name\n1|Name 1\n2|Name 2")

      expect(headers).to eq %w(id name)
      expect(rows.size).to eq 2
      expect(rows[0]).to eq ['1', 'Name 1']
      expect(rows[1]).to eq ['2', 'Name 2']
    end
  end

  describe '#render_success' do
    let(:render) do
      renderer.render_success({ id:1, rows: "id|name\n1|Name 1\n2|Name 2\n" })
    end

    it { expect(render).to include 'Consulta correcta!' }
    it { expect(render).to include 'sqlite_success' }
    it { expect(render).not_to include 'sqlite_error' }
    end

  describe '#render_error' do
    let(:error) { 'Las consultas no coinciden!' }
    let(:render) do
      result = { id:1, rows: "id|name\n1|Name 1\n2|Name 2\n" }
      solution = { id:1, rows: "name\nName 1\nName 2\n" }
      renderer.render_error(result, solution, error)
    end

    it { expect(render).to include error }
    it { expect(render).to include 'sqlite_error' }
    it { expect(render).not_to include 'sqlite_success' }
  end

end
