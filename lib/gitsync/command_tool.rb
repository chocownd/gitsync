class CommandTool
  def self.exccmd(cmd)
    result = system cmd
    !result.nil? && result
  end
end