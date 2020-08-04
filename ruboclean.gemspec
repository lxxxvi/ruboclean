# frozen_string_literal: true

require_relative 'lib/ruboclean/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruboclean'
  spec.version       = Ruboclean::VERSION
  spec.authors       = ['lxxxvi']
  spec.email         = ['lxxxvi@users.noreply.github.com']

  spec.summary       = 'Cleans and orders settings in .rubocop.yml'
  spec.description   = 'Cleans and orders settings in .rubocop.yml'
  spec.homepage      = 'https://github.com/lxxxvi/ruboclean'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lxxxvi/ruboclean'
  spec.metadata['changelog_uri'] = 'https://github.com/lxxxvi/ruboclean/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables << 'ruboclean'
  spec.require_paths = ['lib']
end
