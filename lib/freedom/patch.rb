# frozen_string_literal: true

require_relative 'patch_checker'

module Freedom
  # Extend a `Freedom::Patch` onto your monkey-patch to add behavior for checking
  # compatibility of the patch with the module or class that you are mixing
  # into. Freedom patches can add compatibility checking for either instance
  # methods or class/module methods.
  #
  # Note that you currently cannot define a freedom patch that defines both
  # instance and class methods. `Module.include` and `Method.extend` do not
  # naturally allow you to handle both.
  module Patch
    # Builds a freedom patch for the given method type
    #
    # This patch can safely monkey-patch a module or class and ensure that none
    # of the methods conflict with methods already defined on the base.
    #
    # @api public
    #
    # @example Creates a patch that adds the `#quack` method.
    #   module Quacking
    #     extend Freedom::Patch.(:instance_method)
    #
    #     def quack
    #       'quack'
    #     end
    #   end
    #
    #   class Duck
    #     include Quacking
    #   end
    #
    #   duck = Duck.new
    #   duck.quack  #=> 'quack'
    #
    # @example Creates a patch that adds class introspection.
    #   module ClassIntrospection
    #     extend Freedom::Patch.(:class_method)
    #
    #     def methods_with_owners
    #       methods
    #         .group_by { |method_name| method(method_name).owner }
    #     end
    #   end
    #
    #   Integer.extend ClassIntrospection
    #   Integer.methods_with_owners
    #
    # @param method_type [Symbol] the type of methods to check against the
    #   freedom patch, one of :instance_method or :class_method
    #
    # @return [Module] the module that defines the freedom patch checking
    #   behavior
    def self.call(method_type = :instance_method)
      Module.new.tap do |patch|
        case method_type
        when :class_method then define_hook(patch, :extended, method_type: :method)
        else define_hook(patch, :included, method_type: :instance_method)
        end
      end
    end

    # Adds an hook to the patch for checking a specific type of method
    #
    # @private
    # @api private
    #
    # @param patch [Module] the base module being defined as a `Freedom::Patch`
    # @param hook_name [Symbol] the hook to define, one of :extended or :included
    # @param method_type [Symbol] the type of method to check, one of
    #   :instance_method or :method
    # @return [void]
    def self.define_hook(patch, hook_name, method_type:)
      patch.define_singleton_method(:extended) do |mod|
        mod.define_singleton_method(hook_name) do |base|
          conflicts = PatchChecker.check_methods(
            base,
            against: mod,
            method_type: method_type
          )

          raise Freedom::IncompatiblePatch.new(base, conflicts, mod) if conflicts.any?
        end
      end
    end
    private_class_method :define_hook
  end
end
