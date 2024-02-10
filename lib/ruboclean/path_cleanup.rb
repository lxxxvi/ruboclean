# frozen_string_literal: true

module Ruboclean
  # Cleans up any `Include` or `Exclude` paths that don't exist.
  # The `Include` and `Exclude` paths are relative to the directory
  # where the `.rubocop.yml` file is located. If a path includes a
  # wildcard, it's assumed to be valid.
  class PathCleanup
    def initialize(configuration_hash)
      @configuration_hash = configuration_hash
    end

    def cleanup
      %i[Include Exclude].each do |kind|
        select_stanzas(kind).each do |cop|
          paths = @configuration_hash.dig(cop, kind)
          paths&.select! { |path| regexp_or_wildcard?(path) || File.exist?(path) }
        end
      end

      @configuration_hash
    end

    def select_stanzas(kind)
      @configuration_hash.filter_map do |cop, value|
        next unless value.is_a?(Hash)

        cop if value.key?(kind)
      end
    end

    def regexp_or_wildcard?(path)
      path.is_a?(Regexp) || path.include?("*")
    end
  end
end
