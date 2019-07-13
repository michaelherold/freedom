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
        when :class_method
          patch.define_singleton_method(:extended, &method(:define_extended_hook))
        else
          patch.define_singleton_method(:extended, &method(:define_included_hook))
        end
      end
    end

    # Adds an included hook to the extended module for adding instance methods
    #
    # @api private
    #
    # @param mod [Module] the base module being defined as a `Freedom::Patch`
    # @return [void]
    def self.define_included_hook(mod)
      mod.define_singleton_method(:included) do |base|
        conflicts = PatchChecker.check_methods(
          base,
          against: mod,
          method_type: :instance_method
        )

        raise Freedom::IncompatiblePatch.new(base, conflicts, mod) if conflicts.any?
      end
    end
    private_class_method :define_included_hook

    # Adds an extended hook to the extended module for adding singleton methods
    #
    # @api private
    #
    # @param mod [Module] the base module being defined as a `Freedom::SingletonPatch`
    # @return [void]
    def self.define_extended_hook(mod)
      mod.define_singleton_method(:extended) do |base|
        conflicts = PatchChecker.check_methods(
          base,
          against: mod,
          method_type: :method
        )

        raise Freedom::IncompatiblePatch.new(base, conflicts, mod) if conflicts.any?
      end
    end
    private_class_method :define_extended_hook
  end
end
