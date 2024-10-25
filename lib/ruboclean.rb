# frozen_string_literal: true

require "ruboclean/cli_arguments"
require "ruboclean/orderer"
require "ruboclean/logger"
require "ruboclean/grouper"
require "ruboclean/path_cleanup"
require "ruboclean/runner"
require "ruboclean/stream_writer"
require "ruboclean/to_yaml_converter"
require "ruboclean/version"

# Ruboclean entry point
module Ruboclean
  def self.run_from_cli!(args)
    runner = Runner.new(args)
    logger = Ruboclean::Logger.new(runner.verbose? ? :verbose : :none)

    logger.verbose "Using path '#{runner.path}' ... "
    changed = runner.run!
    logger.verbose post_execution_message(changed, runner.verify?)

    exit !changed if runner.verify?
    exit 0
  end

  def self.post_execution_message(changed, verify)
    if changed
      if verify
        "needs clean.\n"
      else
        "done.\n"
      end
    else
      "already clean.\n"
    end
  end
end
