require "gitsync/version"
require 'gitsync/exceptions/gitsync_error'
require 'gitsync/command_tool'

module Gitsync
  SYNC_BRANCH = 'git-sync-up'.freeze

  def self.up
    begin
      raise_if_git_not_inited
      git_up
      raise_if_syncup_branch_exist
      head = stash_all
      create_syncup_branch head
      push_syncup_branch
      checkout_working_branch
    rescue GitsyncError => e
      puts e.message
    end
  end

  def self.raise_if_git_not_inited
    raise GitsyncError, 'git is not inited' unless check_repo_exist
  end

  def self.git_up
    raise NotImplementedError
  end

  def self.raise_if_syncup_branch_exist
    raise NotImplementedError
  end

  def self.stash_all
    raise NotImplementedError
  end

  def self.create_syncup_branch(head)
    raise NotImplementedError
  end

  def self.push_syncup_branch
    raise NotImplementedError
  end

  def self.checkout_working_branch
    raise NotImplementedError
  end

  def self.check_repo_exist
    CommandTool.exccmd 'git branch 1> /dev/null 2>&1'
  end
end
