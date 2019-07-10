# frozen_string_literal: true

module Freedom
  # Checks a `Freedom::Patch` for compatibility with base modules and classes
  #
  # @api private
  class PatchChecker
    # Checks methods out of a list for conflicts with the patch
    #
    # @api private
    #
    # @param base [Class, Module] the base class or module to be patched
    # @param against [Module] the module defined as a freedom patch
    # @param method_type [Symbol] the type of method to check for compatibility
    # @return [Array<Symbol>] the list of conflicting methods
    def self.check_methods(base, against:, method_type:)
      base_methods = base.__send__("#{method_type}s")
      checker = base.method(method_type)

      against.instance_methods.select do |method|
        base_methods.include?(method) && checker.call(method).owner != against
      end
    end
  end
end
