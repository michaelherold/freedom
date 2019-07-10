# frozen_string_literal: true

require File.expand_path(File.join('lib', 'freedom', 'version'), __dir__)

Gem::Specification.new do |spec|
  spec.name    = 'freedom'
  spec.version = Freedom::VERSION
  spec.authors = ['Michael Herold']
  spec.email   = ['opensource@michaeljherold.com']

  spec.summary     = 'Safe freedom patches for all'
  spec.description = <<-DESC.gsub(/[[:space:]]+/, ' ').strip
    Freedom gives you tools to liberally build monkey patches for your application
    in a safe way that prevents you from overriding methods that you do not intend
    to override. This makes it easier for you to introduce a fix to library code
    without the danger that a later upgrade can break the monkey patch.

    Safe monkey patches == freedom patches!
  DESC
  spec.homepage    = 'https://github.com/michaelherold/freedom'
  spec.license     = 'MIT'

  spec.files = %w[CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md LICENSE.md README.md]
  spec.files += %w[freedom.gemspec]
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
end
