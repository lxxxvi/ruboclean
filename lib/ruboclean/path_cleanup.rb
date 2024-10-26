# frozen_string_literal: true

module Ruboclean
  # Cleans up any `Include` or `Exclude` paths that don't exist.
  # The `Include` and `Exclude` paths are relative to the directory
  # where the `.rubocop.yml` file is located. If a path includes a
  # regexp, it's assumed to be valid.
  # If all entries in `Include` or `Exclude` are removed, the entire property is removed.
  # If a Cop gets entirely truncated due to removing all `Includes` and/or `Exclude`, the Cop itself will be removed.
  class PathCleanup
    def initialize(configuration_hash, options:)
      @configuration_hash = configuration_hash
      @options = options
    end

    def cleanup
      return configuration_hash if options.preserve_paths?

      configuration_hash.each_with_object({}) do |(top_level_key, top_level_value), hash|
        result = process_top_level_value(top_level_value)

        next if Array(result).empty? # No configuration keys left in the cop, remove the entire cop

        hash[top_level_key] = result
      end
    end

    private

    attr_reader :configuration_hash, :options

    def root_directory
      options.input_path.dirname
    end

    # top_level_value could be something like this:
    #
    # {
    #   Include: [...],
    #   Exclude: [...],
    #   EnforcedStyle: "..."
    # }
    #
    # We process it further in case of a Hash.
    def process_top_level_value(top_level_value)
      return top_level_value unless top_level_value.is_a?(Hash)

      top_level_value.each_with_object({}) do |(cop_property_key, cop_property_value), hash|
        result = process_cop_property(cop_property_key, cop_property_value)

        next if Array(result).empty? # No entries left, will skip adding the key to the hash

        hash[cop_property_key] = result
      end
    end

    def process_cop_property(cop_property_key, cop_property_value)
      return cop_property_value unless %w[Include Exclude].include?(cop_property_key.to_s)
      return cop_property_value unless cop_property_value.respond_to?(:filter_map)

      cop_property_value.find_all do |item|
        path_exists?(item)
      end
    end

    def path_exists?(item)
      regexp_pattern?(item) ||
        specific_path_exists?(item) ||
        any_global_command_pattern?(item)
    end

    def specific_path_exists?(item)
      root_directory.join(item).exist?
    end

    def any_global_command_pattern?(item)
      root_directory.glob(item).any?
    end

    # We don't support Regexp, so we just say it exists.
    def regexp_pattern?(item)
      item.is_a?(Regexp)
    end
  end
end
