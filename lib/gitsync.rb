require "gitsync/version"
require 'gitsync/exceptions/gitsync_error'
require 'gitsync/command_tool'

# TODO: indicate remote not only origin
module Gitsync
  SYNC_BRANCH = 'git-sync-up'.freeze

  def self.up
    raise_if_git_not_inited
    prune_remote
    raise_if_syncup_branch_exist
    stash_all
    create_syncup_branch
    push_syncup_branch
    tear_down
  rescue GitsyncError => e
    puts e.message
  end

  def self.down
    raise_if_git_not_inited
    prune_remote
    raise_if_remote_syncup_branch_not_exist
    fetch_remote_syncup_branch
    apply_remote_syncup_branch
    delete_remote_syncup_branch
    prune_remote
  rescue GitsyncError => e
    puts e.message
  end

  def self.raise_if_git_not_inited
    puts 'check git repository exist...'
    result = CommandTool.exccmd('git branch')
    raise GitsyncError, fail_msg('git is not inited') unless result[:succ]
    puts 'exist!'
  end

  def self.prune_remote
    puts 'try prune remote'
    result = CommandTool.exccmd 'git remote prune origin'
    raise GitsyncError, fail_msg('git remote prune failed', result[:msg]) unless
        result[:succ]
    puts 'remote prune success!'
  end

  def self.raise_if_syncup_branch_exist
    puts 'check is sync-up branch already exist...'
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
    puts 'not exist!'
  end

  def self.raise_if_remote_syncup_branch_not_exist
    puts 'check sync-up branch exist in remote...'
    result = CommandTool.exccmd('git ls-remote --heads --exit-code ' \
                                    "origin #{SYNC_BRANCH}")
    unless result[:succ]
      raise GitsyncError, fail_msg('sync-up branch is not exist in remote',
                                   result[:msg])
    end
    puts 'found!'
  end

  def self.stash_all
    puts 'try create temporary stash...'
    result = CommandTool.exccmd 'git stash --include-untracked'
    if !result[:succ]
      raise GitsyncError, fail_msg('stash failed', result[:msg])
    elsif result[:msg].include? 'No local changes to save'
      raise GitsyncError, fail_msg('no local changes to sync up')
    end
    puts 'stashing success!'
  end

  def self.create_syncup_branch
    puts 'try create sync-up branch...'
    result = CommandTool.exccmd "git branch #{SYNC_BRANCH} stash@{0}"
    unless result[:succ]
      raise GitsyncError, fail_msg('create syncup branch failed', result[:msg])
    end
    puts "create branch '#{SYNC_BRANCH}' success!"
  end

  def self.push_syncup_branch
    puts 'try push sync-up branch...'
    result = CommandTool.exccmd "git push origin #{SYNC_BRANCH}:#{SYNC_BRANCH}"
    unless result[:succ]
      raise GitsyncError, fail_msg('push syncup branch failed', result[:msg])
    end
    puts "push branch '#{SYNC_BRANCH}' success!"
  end

  def self.fetch_remote_syncup_branch
    puts 'try fetch remote sync-up branch...'
    result = CommandTool.exccmd "git fetch origin #{SYNC_BRANCH}"
    unless result[:succ]
      raise GitsyncError, fail_msg('fetch syncup branch failed', result[:msg])
    end
    puts 'fetch success!'
  end

  def self.apply_remote_syncup_branch
    raise NotImplementedError
  end

  def self.delete_remote_syncup_branch
    raise NotImplementedError
  end

  def self.tear_down
    puts 'try get rid of local sync-up branch...'
    result = CommandTool.exccmd "git branch -D #{SYNC_BRANCH}"
    unless result[:succ]
      raise GitsyncError, fail_msg('delete syncup branch failed', result[:msg])
    end
    puts "delete branch '#{SYNC_BRANCH}' success!"
    puts 'try get rid of temporary stash...'
    result = CommandTool.exccmd 'git stash drop stash@{0}'
    unless result[:succ]
      raise GitsyncError, fail_msg('drop stash failed', result[:msg])
    end
    puts 'drop temporary stash success!'
  end

  def self.fail_msg(head, msg = nil)
    "fatal: #{head}\n#{msg}"
  end
end
