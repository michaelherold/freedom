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
    # @param patch [Module] the module defined as a `Freedom::Patch`
    # @param mod [Module] the module of class methods in the `Freedom::Patch`
    # @param methods [Array<Symbol>] the list of methods currently defined on `base`
    # @return [void]
    # @raise [Freedom::IncompatiblePatch] when the patch conflicts with the base
    def self.check_methods(base:, patch:, mod:, methods:)
      mod.instance_methods.each do |method|
        raise Freedom::IncompatiblePatch.new(base, method, patch) if methods.include?(method)
      end
    end
  end
end
