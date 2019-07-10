# frozen_string_literal: true

require 'freedom/errors'
require 'freedom/patch'
require 'freedom/version'

# Freedom gives you tools to liberally build monkey patches for your application
# in a safe way that prevents you from overriding methods that you do not intend
# to override. This makes it easier for you to introduce a fix to library code
# without the danger that a later upgrade can break the monkey patch.
#
# Safe monkey patches == freedom patches!
module Freedom
end
