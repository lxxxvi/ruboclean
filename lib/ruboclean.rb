# frozen_string_literal: true

require 'ruboclean/version'
require 'ruboclean/rubocop_configuration'
require 'ruboclean/rubocop_configuration_path'
require 'ruboclean/orderer'

module Ruboclean
  class Error < StandardError; end

  def self.run(path)
    rubocop_configuration_path = RubocopConfigurationPath.new(path)
    rubocop_configuration = rubocop_configuration_path.load
    rubocop_configuration_path.write(rubocop_configuration.order)
  end
end
