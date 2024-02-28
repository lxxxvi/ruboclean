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
    logger = Ruboclean::Logger.new(runner.verbose? ? :verbose : :none)
    logger.verbose "Using path '#{runner.path}' ... "
    have_no_change = !runner.run!

    logger.verbose "done.\n"

    exit have_no_change if runner.verify?
    exit 0
  end
end
