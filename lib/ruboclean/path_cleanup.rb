# frozen_string_literal: true

module Ruboclean
  # Cleans up any `Include` or `Exclude` paths that don't exist.
  # The `Include` and `Exclude` paths are relative to the directory
  # where the `.rubocop.yml` file is located. If a path includes a
  # wildcard, it's assumed to be valid.
  class PathCleanup
    def initialize(config_hash)
      @config_hash = config_hash
    end

    def cleanup
      %i[Include Exclude].each do |kind|
        select_stanzas(kind).each do |cop|
          paths = @config_hash.dig(cop, kind.to_s) || @config_hash.dig(cop, kind.to_sym)
          paths&.select! { |path| regexp_or_wildcard?(path) || File.exist?(path) }
        end
      end

      @config_hash
    end

    def select_stanzas(kind)
      @config_hash.each_with_object([]) do |item, result|
        cop, value = item
        next unless value.is_a?(Hash)

        result << cop if value.key?(kind.to_s) || value.key?(kind.to_sym)
      end
    end

    def regexp_or_wildcard?(path)
      path.is_a?(Regexp) || path.include?("*")
    end
  end
end
