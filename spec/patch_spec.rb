# frozen_string_literal: true

RSpec.describe Freedom::Patch do
  context 'when the patch does not conflict with any methods on the class' do
    it 'applies without raising an exception' do
      klass = Class.new { def foo; 'foo from class'; end }
      module ConflictOnBar
        extend Freedom::Patch

        module InstanceMethods
          def bar
            'bar from patch'
          end
        end
      end

      expect { klass.include ConflictOnBar }.not_to raise_error
      expect(klass.new.bar).to eq('bar from patch')
    end
  end

  context 'when the patch has a conflicting instance method on the class' do
    it 'raises an exception when included' do
      klass = Class.new { def foo; 'foo from class'; end }
      module ConflictOnFoo
        extend Freedom::Patch

        module InstanceMethods
          def foo
            'foo from patch'
          end
        end
      end

      expect { klass.include ConflictOnFoo }.to raise_error(Freedom::IncompatiblePatch)
    end
  end
end
