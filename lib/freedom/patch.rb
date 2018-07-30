# frozen_string_literal: true

require_relative 'patch_checker'

module Freedom
  # Extend `Freedom::Patch` onto your monkey-patch to add behavior for checking
  # compatibility of the patch with the module or class that you are mixing
  # into.
  #
  # @example Creates a patch that add the `#foo` method.
  #   module Fooable
  #     extend Freedom::Patch
  #
  #     module InstanceMethods
  #       def foo
  #         'foo from Fooable'
  #       end
  #     end
  #   end
  module Patch
    # Extends a module with the safety properties of a `Freedom::Patch`
    #
    # @api private
    #
    # @param base [Module] the base module being defined as a `Freedom::Patch`
    # @return [void]
    def self.extended(base)
      define_included_hook(base)
    end

    # Adds an included hook to the extended module for adding instance methods
    #
    # @api private
    #
    # @param mod [Module] the base module being defined as a `Freedom::Patch`
    # @return [void]
    def self.define_included_hook(mod)
      mod.define_singleton_method(:included) do |base|
        if mod.const_defined?(:InstanceMethods)
          methods_mod = mod.const_get(:InstanceMethods)
          PatchChecker.check_methods(base: base, patch: mod, mod: methods_mod, methods: base.instance_methods)
          base.include methods_mod
        end
        if mod.const_defined?(:ClassMethods)
          methods_mod = mod.const_get(:ClassMethods)
          PatchChecker.check_methods(base: base, patch: mod, mod: methods_mod, methods: base.methods)
          base.extend methods_mod
        end
      end
    end
    private_class_method :define_included_hook
  end
end
