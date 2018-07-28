# frozen_string_literal: true

module Freedom
  # Checks a `Freedom::Patch` for compatibility with base modules and classes
  #
  # @api private
  class PatchChecker
    # Checks the instance methods on the base for conflicts with the patch
    #
    # @api private
    #
    # @param base [Class, Module] the base class or module to be patched
    # @param patch [Module] the module defined as a `Freedom::Patch`
    # @param mod [Module] the module of instance methods in the `Freedom::Patch`
    # @return [void]
    # @raise [Freedom::IncompatiblePatch] when the patch conflicts with the base
    def self.check_instance_methods(base:, patch:, mod:)
      mod.instance_methods.each do |method|
        if base.instance_methods.include?(method)
          raise Freedom::IncompatiblePatch.new(base, method, patch)
        end
      end
    end
  end
end
