describe Qsim::HtmlRenderer do
  describe '#render' do
    it 'renders memory by default' do
      expect(render).to include 'Records', 'R0', 'CAFE', 'R7', 'BABE'
      expect(render).not_to include 'Memory', 'Flags', 'Special', 'Symbols', 'SP', '0007'
    end

    it 'renders all categories' do
      rendering = render(memory: { from: '0007', to: '000B' },
                         flags: true,
                         records: true,
                         special_records: true)
      expect(rendering).to include 'Memory', 'Flags', 'Special records', 'Records'
      expect(rendering).not_to include '000C'
    end

    context 'when memory is specified' do
      it 'renders the range' do
        rendering = render(memory: { from: '0007', to: '0012' })
        expect(rendering).to include 'Memory', '0007', '0011'
      end

      it 'fills the unspecified records with zero' do
        rendering = render(memory: { from: '0001', to: '0002' })
        expect(rendering).to include '0000'
      end
    end

    context 'when there is no output' do
      it 'only contains style tags' do
        rendering = render({})
        expect(rendering).to match %r{<style>(.|\s)+</style>\s+$}
      end
    end

    def render(output = { records: true })
      result = { records: { R0: 'CAFE', R7: 'BABE' },
                 memory: { '0007': '0001', '000A' => '00AA' },
                 flags: { N: 0, Z: 0, V: 0, C: 1 },
                 special_records: { SP: 'FFEF' } }
      result.deep_symbolize_keys!
      Qsim::HtmlRenderer.new.render(result, output)
    end
  end
end
