![Continuous Integration](https://github.com/lxxxvi/ruboclean/workflows/Continuous%20Integration/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/a940762e1c0b27caa905/maintainability)](https://codeclimate.com/github/lxxxvi/ruboclean/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a940762e1c0b27caa905/test_coverage)](https://codeclimate.com/github/lxxxvi/ruboclean/test_coverage)

# ruboclean

**ruboclean** puts `.rubocop.yml` into order. It groups the configuration into three groups:

1. "Base"-configuration like `require`, `inherit_from`, etc.
2. `Namespaces`
3. `Namespace/Cops`

Finally it orders the configurations **alphabetically** within these groups.

## Main example

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
  - path/file_exists.rb
  - path_with_files/**/*
  - path/file_does_not_exist.rb # This entry will be removed if the file doesn't exist. Skip with --preserve-paths option.
  - path_without_files/**/* # Will be removed if no files within pattern exist. Skip with --preserve-paths option.

# Preceding comments will be removed unless the --preserve-comments option is used.
require:
- rubocop-rails # Inline comments will always be removed.
```

### Output `.rubocop.yml`:

```yml
---

require:
- rubocop-rails

AllCops:
  Exclude:
  - path/file_exists.rb
  - path_with_files/**/*

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
gem "ruboclean", require: false
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install ruboclean
```

## Command synopsis

```shell
ruboclean [input] \
  [--stdin] \
  [--output=/path/to/file.yml] \
  [--silent] \
  [--preserve-comments] \
  [--preserve-paths] \
  [--verify]
```

### Parameters

#### `input`

Can be a directory that contains a `.rubocop.yml`, or a path to a `.rubocop.yml` directly.
Defaults to the current working directory.

##### Examples

```shell
ruboclean                             # uses `.rubocop.yml` of current working directory
ruboclean /path/to/dir                # uses `.rubocop.yml` of /path/to/dir
ruboclean /path/to/dir/.rubocop.yml
```

#### `--stdin`

It's possible to read from `STDIN`, for example:

```shell
echo "SomeConfig: True" | ruboclean --stdin
```

Using `STDIN` will automatically set the output to `STDOUT`. You can use the `--output` flag to override this.

Also, if you use `STDIN`, your current working directory should be the root directory of your project, so that the
cleanup of unused paths/references (see `--preserve-paths`) works properly. If your current working directory
is something else, you have to explicitly provide the project's root directory using the `input` argument.

```shell
echo "SomeConfig: True" | ruboclean /path/to/the/project/directory --stdin
```

#### `--output=/path/to/file.yml`

Output path where the result is written to.
Can be absolute or relative to the current working directory.
`--output=STDOUT` prints it to `STDOUT` and not to a file, and silences all logging (see `--silent`).

##### Examples

```shell
ruboclean --output=/absolute/path.yml
ruboclean --output=relative/path.yml    # relative to current working directory
ruboclean --output=STDOUT               # does not write anything to a file
```

#### `--silent`

Suppress any log output displayed on the screen when executing the command.
Using `--output=STDOUT` also forces this.

#### `--preserve-comments`

Preserves **preceding** comments for each top-level entry in the configuration.
Inline comments are **not** preserved.

See main example above for explanation.

#### `--preserve-paths`

Skips the path cleanup that are applied against `Include:` and `Exclude:` configurations.

See main example above for explanation.

#### `--verify`

Executes in dry-run mode. Exits with `1` if changes are needed, otherwise `0`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lxxxvi/ruboclean. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lxxxvi/ruboclean/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruboclean project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lxxxvi/ruboclean/blob/main/CODE_OF_CONDUCT.md).
