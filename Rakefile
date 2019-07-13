# frozen_string_literal: true

require 'bundler/gem_tasks'

# Defines a Rake task if the optional dependency is installed
#
# @param disabled [Boolean] when truthy, do not run the block
#
# @return [nil]
def with_optional_dependency(disabled = false)
  yield if block_given? && !disabled
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

default = %w[spec]

with_optional_dependency do
  require 'yard-doctest'
  task 'yard:doctest' do
    command = 'yard doctest'
    success = system(command)

    abort "\nYard Doctest failed: #{$CHILD_STATUS}" unless success
  end

  default << 'yard:doctest'
end

with_optional_dependency do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)

  default << 'rubocop'
end

with_optional_dependency(ENV['CI']) do
  require 'yard/rake/yardoc_task'
  YARD::Rake::YardocTask.new(:yard)

  default << 'yard'
end

with_optional_dependency do
  require 'inch/rake'
  Inch::Rake::Suggest.new(:inch)

  default << 'inch'
end

with_optional_dependency(ENV['CI']) do
  require 'yardstick/rake/measurement'
  require 'yardstick/rake/verify'

  namespace :yardstick do
    options = YAML.load_file('.yardstick.yml')

    Yardstick::Rake::Measurement.new(:measure, options) do |measurement|
      measurement.output = 'coverage/docs.txt'
    end

    Yardstick::Rake::Verify.new(:verify, options) do |verify|
      verify.threshold = 100
    end
  end

  desc 'Measure and verify the amount of documentation coverage'
  task yardstick: %w[yardstick:measure yardstick:verify]

  default << 'yardstick'
end

task default: default
