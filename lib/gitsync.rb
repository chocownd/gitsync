require "gitsync/version"
require 'gitsync/exceptions/gitsync_error'

module Gitsync
  def self.up
    raise NotImplementedError
  end

  def self.raise_if_git_not_inited
    raise GitsyncError, 'git is not inited' unless check_repo_exist
  end

  def self.exccmd(cmd)
    result = system cmd
    !result.nil? && result
  end

  def self.check_repo_exist
    exccmd 'git branch 1> /dev/null 2>&1'
  end
end
