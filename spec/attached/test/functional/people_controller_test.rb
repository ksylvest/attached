require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  
  test "create valid person" do
    post(:create, :person => { :name => "Kevin", :avatar => fixture_file_upload('people/avatars/avatar.jpeg') })
  end
  
  test "create person without avatar" do
    post(:create, :person => { :name => "Kevin" })
  end
  
end
