# Freedom

[![Build Status](https://travis-ci.org/michaelherold/freedom.svg)][travis]
[![Code Climate](https://codeclimate.com/github/michaelherold/freedom/badges/gpa.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/michaelherold/freedom.svg?branch=master)][inch]

[codeclimate]: https://codeclimate.com/github/michaelherold/freedom
[inch]: http://inch-ci.org/github/michaelherold/freedom
[travis]: https://travis-ci.org/michaelherold/freedom

Freedom is a library that allows you define safe "freedom patches" that extend existing classes, but prevent breakage when you update the library that you're patching and the patch conflicts with the update.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'freedom'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install freedom

## Usage

Defining a freedom patch is a simple affair. Currently, you have two options, depending on which type of methods you want to check against: instance methods or class methods.

### Checking for collisions with instance methods

To check a freedom patch's methods against the instance methods of its includer, define the patch like so:

```ruby
module Quacking
  extend Freedom::Patch.(:instance_method)

  def quack
    'quack from Quacking'
  end
end
```

Once you've done so, `include` the module just like you would a traditional Ruby patch:

```ruby
class Duck
  include Quacking
end
```

### Checking for collisions with class methods

To check a freedom patch's methods against the class methods of its extender, define the patch like so:

```ruby
module ClassIntrospection
  extend Freedom::Patch.(:class_method)

  def methods_with_owners
    methods
      .group_by { |method_name| method(method_name).owner }
  end
end
```

After that, you can `extend` a class just like you normally would:

```ruby
class Integer
  extend ClassIntrospection
end
```

### Important Note

Freedom patches are intended only to protect you when you are monkey-patching code that already exists. They currently _will not_ protect you if you include a module and then later redefine the method, like the following example:

```ruby
module Quacking
  extend Freedom::Patch.(:instance_method)

  def quack
    'quack'
  end
end

class Duck
  include Quacking

  def quack
    'quack from Duck'
  end
end
```

## Contributing

So you’re interested in contributing to Freedom? Check out our [contributing guidelines](CONTRIBUTING.md) for more information on how to do that.

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby versions:

* Ruby 2.4
* Ruby 2.5
* Ruby 2.6
* JRuby 9.2

If something doesn't work on one of these versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby versions, however support will only be provided for the versions listed above.

If you would like this library to support another Ruby version or implementation, you may volunteer to be a maintainer. Being a maintainer entails making sure all tests run and pass on that implementation. When something breaks on your implementation, you will be responsible for providing patches in a timely fashion. If critical issues for a particular implementation exist at the time of a major release, support for that Ruby version may be dropped.

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations of this scheme should be reported as bugs. Specifically, if a minor or patch version is released that breaks backward compatibility, that version should be immediately yanked and/or a new version should be immediately released that restores compatibility. Breaking changes to the public API will only be introduced with new major versions. As a result of this policy, you can (and should) specify a dependency on this gem using the [Pessimistic Version Constraint][pessimistic] with two digits of precision. For example:

    spec.add_dependency "freedom", "~> 0.1"

[pessimistic]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[semver]: http://semver.org/spec/v2.0.0.html

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
