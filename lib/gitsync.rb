require "gitsync/version"

module Gitsync
  def self.up
    raise NotImplementedError
  end

  def self.exccmd(cmd)
    result = system cmd
    !result.nil? && result
  end
end
