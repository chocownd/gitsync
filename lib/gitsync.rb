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
      stash_all
      create_syncup_branch
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
    result = CommandTool.exccmd 'git pull --rebase --autostash'
    raise GitsyncError, fail_msg('git up failed', result[:msg]) unless
        result[:succ]
  end

  def self.raise_if_syncup_branch_exist
    result = CommandTool.exccmd "git show-branch #{SYNC_BRANCH}"

    if result[:succ]
      raise GitsyncError, fail_msg('syncup branch is already exist',
                                   result[:msg])
    end
  end

  def self.stash_all
    result = CommandTool.exccmd 'git stash --include-untracked'
    raise GitsyncError, fail_msg('stash failed', result[:msg]) unless
        result[:succ]
  end

  def self.create_syncup_branch
    result = CommandTool.exccmd "git branch #{SYNC_BRANCH} stash@{0}"
    unless result[:succ]
      raise GitsyncError, fail_msg('create syncup branch failed', result[msg])
    end
  end

  def self.push_syncup_branch
    raise NotImplementedError
  end

  def self.checkout_working_branch
    raise NotImplementedError
  end

  def self.check_repo_exist
    CommandTool.exccmd('git branch')[:succ]
  end

  def self.fail_msg(head, msg)
    head + "\n" + msg
  end
end
