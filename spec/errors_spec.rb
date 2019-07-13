# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Freedom::IncompatiblePatch do
  describe '#inspect' do
    it 'renders a readable representation of the error' do
      MyModule = Module.new

      error = described_class.new(Integer, %w[foo], MyModule)

      expect(error.inspect).to(
        eq(
          '#<Freedom::IncompatiblePatch: Integer already defines ' \
          "`foo', also defined on MyModule>"
        )
      )
    end
  end
end
