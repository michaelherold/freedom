# frozen_string_literal: true

RSpec.describe Freedom::Patch do
  context 'when the patch does not conflict with any methods on the class' do
    let(:klass) do
      Class.new do
        def foo; end
      end
    end

    let(:patch) do
      Module.new do
        extend Freedom::Patch

        def bar
          'bar'
        end
      end
    end

    it 'applies without raising an exception' do
      expect { klass.include patch }.not_to raise_error

      expect(klass.new.bar).to eq('bar')
    end
  end
end
