require 'test_helper'

class CommandToolTest < Minitest::Test
  def test_exccmd
    invalid_cmd = CommandTool.exccmd 'ls ------very-illegal-option'
    assert !invalid_cmd[:succ]
    valid_cmd = CommandTool.exccmd 'ls'
    assert valid_cmd[:succ]
  end
end