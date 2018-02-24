require "gitsync/version"

module Gitsync
  def self.up
    raise NotImplementedError
  end

  def self.exccmd(cmd)
    result = system cmd
    !result.nil? && result
  end

  def self.check_repo_exist
    exccmd 'git branch 1> /dev/null 2>&1'
  end
end
