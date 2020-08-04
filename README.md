![Continuous Integration](https://github.com/lxxxvi/ruboclean/workflows/Continuous%20Integration/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/a940762e1c0b27caa905/maintainability)](https://codeclimate.com/github/lxxxvi/ruboclean/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a940762e1c0b27caa905/test_coverage)](https://codeclimate.com/github/lxxxvi/ruboclean/test_coverage)

# ruboclean

**ruboclean** puts `.rubocop.yml` into order. It groups the configuration into three groups:

1. `require`
2. `Namespaces`
3. `Namespace/Cops`

Finally it orders the configurations **alphabetically** within these groups.

## Example

### Input `.rubocop.yml`:

```yml
Rails/ShortI18n:
  Enabled: true

Layout/LineLength:
  Max: 120

Rails:
  Enabled: true

AllCops:
  Exclude:
  - bin/**/*

require:
- rubocop-rails
```

### Output `.rubocop.yml`:

```yml
---

require:
- rubocop-rails

AllCops:
  Exclude:
  - bin/**/*

Rails:
  Enabled: true

Layout/LineLength:
  Max: 120

Rails/ShortI18n:
  Enabled: true

```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboclean', require: false
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install ruboclean
```

## Usage

```shell
ruboclean [path]
```

* `path` is optional, it defaults to the current working directory
* `path` can be a directory that contains a `.rubocop.yml`
* `path` can be a path to a `.rubocop.yml` directly

### Examples

```shell
ruboclean                 # uses `.rubocop.yml` of current working directory
```

```shell
ruboclean /path/to/dir    # uses `.rubocop.yml` of /path/to/dir
```

```shell
ruboclean /path/to/dir/.rubocop.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lxxxvi/ruboclean. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lxxxvi/ruboclean/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruboclean project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lxxxvi/ruboclean/blob/master/CODE_OF_CONDUCT.md).
