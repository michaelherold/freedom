# frozen_string_literal: true

module Freedom
  # The base class for errors within Freedom.
  Error = Class.new(StandardError)

  # Raised when a patch is incompatible with the class or module it's being mixed into.
  class IncompatiblePatch < Error
    # Instantiates a new incompatible patch exception
    #
    # @api private
    #
    # @param base [Class, Module] the base class or module to be patched
    # @param conflicting_method [Symbol] name of the conflicting method
    # @param defining_module [Module] the module that defines the conflicting method
    def initialize(base, conflicting_method, defining_module)
      self.base = base
      self.conflicting_method = conflicting_method
      self.defining_module = defining_module
    end

    # The descriptive message for the exception
    #
    # @api private
    #
    # @return [String] the explanation for what caused the exception to be raised
    def message
      "#{base} already defines method `#{conflicting_method}', " \
      "which is trying to be redefined by #{defining_module}"
    end

    private

    # The base into which the `Freedom::Patch` is applied
    #
    # @api private
    # @return [Class, Module]
    attr_accessor :base

    # The method that is already defined on the base
    #
    # @api private
    # @return [Symbol]
    attr_accessor :conflicting_method

    # The module that is defining the conflicting method
    #
    # @api private
    # @return [Module]
    attr_accessor :defining_module
  end
end
