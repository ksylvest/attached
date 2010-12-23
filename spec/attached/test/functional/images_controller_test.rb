require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @image = images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image" do
    assert_difference('Image.count') do
      post :create, :image => @image.attributes
    end

    assert_redirected_to image_path(assigns(:image))
  end

  test "should show image" do
    get :show, :id => @image.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @image.to_param
    assert_response :success
  end

  test "should update image" do
    put :update, :id => @image.to_param, :image => @image.attributes
    assert_redirected_to image_path(assigns(:image))
  end

  test "should destroy image" do
    assert_difference('Image.count', -1) do
      delete :destroy, :id => @image.to_param
    end

    assert_redirected_to images_path
  end
end
