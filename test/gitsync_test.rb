require "test_helper"

class GitsyncTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Gitsync::VERSION
  end

  def test_exccmd
    assert !Gitsync.exccmd('ls ------very-illegal-option 2> /dev/null')
    assert Gitsync.exccmd('ls 1> /dev/null')
  end
end
