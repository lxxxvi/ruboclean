# frozen_string_literal: true

require "ruboclean/version"
require "ruboclean/arguments"
require "ruboclean/rubocop_configuration"
require "ruboclean/rubocop_configuration_path"
require "ruboclean/runner"
require "ruboclean/orderer"

# Ruboclean entry point
module Ruboclean
  class Error < StandardError; end

  def self.run_from_cli!(command_line_arguments)
    Ruboclean::Arguments.new(command_line_arguments).tap do |arguments|
      print "Using path '#{arguments.path}' ... " if arguments.verbose?
      Runner.new(arguments).run!
      puts "done." if arguments.verbose?
    end
  end
end
