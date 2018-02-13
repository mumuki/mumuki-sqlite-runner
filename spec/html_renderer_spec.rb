
describe Sqlite::HtmlRenderer do

  let(:renderer) { Sqlite::HtmlRenderer.new }

  describe '#render_success' do
    let(:render) do
      result = {
          id:1,
          dataset: Sqlite::Dataset.new("id|name\n1|Name 1\n2|Name 2\n")
      }
      message = I18n.t 'message.success.query'
      renderer.render_success result, message
    end

    it { expect(render).to include I18n.t 'message.success.query' }
  end

  describe '#render_error' do
    let(:error) { I18n.t 'message.failure.columns' }
    let(:render) do
      result = {
          id:1,
          dataset: Sqlite::Dataset.new("id|name\n1|Name 1\n2|Name 2\n")
      }
      solution = {
          id:1,
          dataset: Sqlite::Dataset.new("name\nName 1\nName 2\n")
      }
      renderer.render_error result, solution, error
    end

    it { expect(render).to include error }
  end

end
