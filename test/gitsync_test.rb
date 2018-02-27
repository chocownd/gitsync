require "test_helper"

class GitsyncTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Gitsync::VERSION
  end

  def test_raise_if_git_not_inited
    # assume there are no git repository in root dir
    except = assert_raises GitsyncError do
      Dir.chdir('/') { Gitsync.raise_if_git_not_inited }
    end
    # assume this test file is managed under git vcs
    assert_nil Gitsync.raise_if_git_not_inited
  end

  def test_raise_if_syncup_branch_exist
    Gitsync.raise_if_syncup_branch_exist
  end
end
