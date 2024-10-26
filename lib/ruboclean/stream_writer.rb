# frozen_string_literal: true

module Ruboclean
  # Orders the items within the groups alphabetically
  class StreamWriter
    def initialize(content, options:)
      @content = content
      @options = options
    end

    def write!
      options.output_stream.write(content) unless options.verify?

      content
    end

    private

    attr_reader :content, :options
  end
end
