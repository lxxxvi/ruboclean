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
      configuration_hash.transform_values(&method(:process_top_level_values))
    end

    private

    attr_reader :configuration_hash

    # top_level_value could be something like this:
    #
    # {
    #   Include: [...],
    #   Exclude: [...],
    #   EnforcedStyle: "..."
    # }
    #
    # We process it further in case of a Hash.
    def process_top_level_values(top_level_value)
      return top_level_value unless top_level_value.is_a?(Hash)

      top_level_value.each_with_object({}) do |(cop_property_key, cop_property_value), agg|
        agg[cop_property_key] = process_cop_property(cop_property_key, cop_property_value)
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
      regexp_or_wildcard?(item) || File.exist?(item)
    end

    def regexp_or_wildcard?(path)
      path.is_a?(Regexp) || path.include?("*")
    end
  end
end
