require 'test_helper'

class CommandToolTest < Minitest::Test
  def test_exccmd
    assert !CommandTool.exccmd('ls ------very-illegal-option 2> /dev/null')
    assert CommandTool.exccmd('ls 1> /dev/null')
  end
end