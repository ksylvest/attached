require 'test_helper'

class AttachedTest < ActiveSupport::TestCase
  test "attached is a module" do
    assert_kind_of Module, Attached
  end
end
