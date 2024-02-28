# frozen_string_literal: true

require "ruboclean/cli_arguments"
require "ruboclean/orderer"
require "ruboclean/logger"
require "ruboclean/grouper"
require "ruboclean/path_cleanup"
require "ruboclean/runner"
require "ruboclean/to_yaml_converter"
require "ruboclean/version"

# Ruboclean entry point
module Ruboclean
  def self.run_from_cli!(args)
    runner = Runner.new(args)
    print "Using path '#{runner.path}' ... " if runner.verbose?
    have_no_change = !runner.run!
    puts "done." if runner.verbose?

    exit have_no_change if runner.verify?
    exit 0
  end
end
