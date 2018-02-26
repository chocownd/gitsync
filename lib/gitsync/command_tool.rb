require 'open3'

class CommandTool
  def self.exccmd(cmd)
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      result = wait_thr.value
      return { succ: result.success?,
               msg: stdout.gets(nil) || stderr.gets(nil) }
    end
  rescue StandardError => e
    return { succ: false, msg: e }
  end
end