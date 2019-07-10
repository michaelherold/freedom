# frozen_string_literal: true

RSpec.describe Freedom::Patch do
  context 'instance method patches' do
    context 'when the patch does not conflict with any methods on the class' do
      it 'applies without raising an exception' do
        klass = Class.new { def foo; 'foo from class'; end }
        module ConflictOnBar
          extend Freedom::Patch.(:instance_method)

          def bar
            'bar from patch'
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
          extend Freedom::Patch.(:instance_method)

          def foo
            'foo from patch'
          end
        end

        expect { klass.include ConflictOnFoo }.to raise_error(Freedom::IncompatiblePatch)
      end
    end

    context 'when the patch has multiple conflicting instance methods on the class' do
      it 'raises an exception when included' do
        klass = Class.new { def foo; end; def bar; end }
        module ConflictOnFooAndBar
          extend Freedom::Patch.(:instance_method)

          def foo; 'foo from patch'; end
          def bar; 'bar from patch'; end
        end

        expect { klass.include ConflictOnFooAndBar }.to(
          raise_error(Freedom::IncompatiblePatch, /(?:foo).*(?:bar)/)
        )
      end
    end
  end

  context 'class method patches' do
    context 'when the patch does not conflict with any class methods on the class' do
      it 'applies without raising an exception' do
        klass = Class.new { def self.foo; 'foo from class'; end }
        module ConflictOnSelfBar
          extend Freedom::Patch.(:class_method)

          def bar
            'bar from patch'
          end
        end

        expect { klass.extend ConflictOnSelfBar }.not_to raise_error
        expect(klass.bar).to eq('bar from patch')
      end
    end

    context 'when the patch has a conflicting class method on the class' do
      it 'raises an exception when included' do
        klass = Class.new { def self.foo; 'foo from class'; end }
        module ConflictOnSelfFoo
          extend Freedom::Patch.(:class_method)

          def foo
            'foo from patch'
          end
        end

        expect { klass.extend ConflictOnSelfFoo }.to raise_error(Freedom::IncompatiblePatch)
      end
    end

    context 'when the patch has multiple conflicting class methods on the class' do
      it 'raises an exception when included' do
        klass = Class.new { def self.foo; end; def self.bar; end }
        module ConflictOnSelfFooAndSelfBar
          extend Freedom::Patch.(:class_method)

          def foo; 'foo from patch'; end
          def bar; 'bar from patch'; end
        end

        expect { klass.extend ConflictOnSelfFooAndSelfBar }.to(
          raise_error(Freedom::IncompatiblePatch, /(?:foo).*(?:bar)/)
        )
      end
    end
  end
end
