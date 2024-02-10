# frozen_string_literal: true

require "ruboclean/version"
require "ruboclean/cli_arguments"
require "ruboclean/runner"
require "ruboclean/orderer"
require "ruboclean/path_cleanup"

# Ruboclean entry point
module Ruboclean
  def self.run_from_cli!(args)
    runner = Runner.new(args)
    print "Using path '#{runner.path}' ... " if runner.verbose?
    runner.run!
    puts "done." if runner.verbose?
  end
end
