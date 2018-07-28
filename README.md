# Freedom

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

TODO: Write usage instructions here

## Contributing

So you’re interested in contributing to Freedom? Check out our [contributing guidelines](CONTRIBUTING.md) for more information on how to do that.

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby versions:

* Ruby 2.3
* Ruby 2.4
* Ruby 2.5
* JRuby 9.1
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
