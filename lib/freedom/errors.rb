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
    # @param conflicts [Symbol] name of the conflicting method(s)
    # @param owner [Class, Module] the class or module that owns the conflict
    def initialize(base, conflicts, owner)
      self.base = base
      self.conflicts = conflicts.map { |conflict| "`#{conflict}'" }.join(', ')
      self.owner = owner
    end

    # @private
    def inspect
      "#<#{self.class.name}: #{message}>"
    end

    # The descriptive message for the exception
    #
    # @api private
    #
    # @return [String] the explanation for what caused the exception to be raised
    def message
      "#{base} already defines #{conflicts}, also defined on #{owner}"
    end

    private

    # The base into which the `Freedom::Patch` is applied
    #
    # @api private
    # @return [Class, Module]
    attr_accessor :base

    # The methods that are already defined on the base
    #
    # @api private
    # @return [String]
    attr_accessor :conflicts

    # The module that owns the conflicting method
    #
    # @api private
    # @return [Module]
    attr_accessor :owner
  end
end
