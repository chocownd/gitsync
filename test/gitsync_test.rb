require "test_helper"

class GitsyncTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Gitsync::VERSION
  end

  def test_exccmd
    assert !Gitsync.exccmd('ls ------very-illegal-option 2> /dev/null')
    assert Gitsync.exccmd('ls 1> /dev/null')
  end

  def test_check_repo_exist
    # assume there are no git repository in root dir
    Dir.chdir('/') { assert !Gitsync.check_repo_exist }
    # assume this test file is managed under git vcs
    assert Gitsync.check_repo_exist
  end
end
