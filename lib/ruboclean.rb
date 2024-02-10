# frozen_string_literal: true

require "ruboclean/version"
require "ruboclean/cli_arguments"
require "ruboclean/runner"
require "ruboclean/orderer"
require "ruboclean/path_cleanup"

# Ruboclean entry point
module Ruboclean
  class Error < StandardError; end

  def self.run_from_cli!(args)
    cli_arguments = Ruboclean::CliArguments.new(args)
    print "Using path '#{cli_arguments.path}' ... " if cli_arguments.verbose?
    Runner.new(cli_arguments).run!
    puts "done." if cli_arguments.verbose?
  end
end
