require "gitsync/version"
require 'gitsync/exceptions/gitsync_error'
require 'gitsync/command_tool'

module Gitsync
  SYNC_BRANCH = 'git-sync-up'.freeze

  def self.up
    begin
      raise_if_git_not_inited
      raise_if_syncup_branch_exist
      stash_all
      create_syncup_branch
      push_syncup_branch
      tear_down
    rescue GitsyncError => e
      puts e.message
    end
  end

  def self.raise_if_git_not_inited
    puts 'check git repository exist...'
    result = CommandTool.exccmd('git branch')
    raise GitsyncError, fail_msg('git is not inited') unless
        result[:succ]
  end

  def self.raise_if_syncup_branch_exist
    puts 'check whether sync-up branch is already exist...'
    result = CommandTool.exccmd('git ls-remote --heads --exit-code ' \
                                    "origin #{SYNC_BRANCH}")
    if result[:succ]
      raise GitsyncError, fail_msg('syncup branch is already exist in remote',
                                   result[:msg])
    end

    result = CommandTool.exccmd("git branch | grep -w #{SYNC_BRANCH}")
    if result[:succ]
      raise GitsyncError, fail_msg('syncup branch is already exist in local',
                                   result[:msg])
    end
  end

  def self.stash_all
    puts 'try stash all...'
    result = CommandTool.exccmd 'git stash --include-untracked'
    if !result[:succ]
      raise GitsyncError, fail_msg('stash failed', result[:msg])
    elsif result[:msg].include? 'No local changes to save'
      raise GitsyncError, fail_msg('no local changes to sync up')
    end
  end

  def self.create_syncup_branch
    result = CommandTool.exccmd "git branch #{SYNC_BRANCH} stash@{0}"
    unless result[:succ]
      raise GitsyncError, fail_msg('create syncup branch failed', result[:msg])
    end
  end

  def self.push_syncup_branch
    result = CommandTool.exccmd "git push origin #{SYNC_BRANCH}:#{SYNC_BRANCH}"
    unless result[:succ]
      raise GitsyncError, fail_msg('push syncup branch failed', result[:msg])
    end
  end

  def self.tear_down
    result = CommandTool.exccmd "git branch -D #{SYNC_BRANCH}"
    unless result[:succ]
      raise GitsyncError, fail_msg('delete syncup branch failed', result[:msg])
    end

    result = CommandTool.exccmd 'git stash drop stash@{0}'
    unless result[:succ]
      raise GitsyncError, fail_msg('drop stash failed', result[:msg])
    end
  end

  def self.fail_msg(head, msg = nil)
    "fatal: #{head}\n#{msg}"
  end
end
