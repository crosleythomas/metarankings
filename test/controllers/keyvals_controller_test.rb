require 'test_helper'

class KeyvalsControllerTest < ActionController::TestCase
  setup do
    @keyval = keyvals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:keyvals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create keyval" do
    assert_difference('Keyval.count') do
      post :create, keyval: { key: @keyval.key, value: @keyval.value }
    end

    assert_redirected_to keyval_path(assigns(:keyval))
  end

  test "should show keyval" do
    get :show, id: @keyval
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @keyval
    assert_response :success
  end

  test "should update keyval" do
    patch :update, id: @keyval, keyval: { key: @keyval.key, value: @keyval.value }
    assert_redirected_to keyval_path(assigns(:keyval))
  end

  test "should destroy keyval" do
    assert_difference('Keyval.count', -1) do
      delete :destroy, id: @keyval
    end

    assert_redirected_to keyvals_path
  end
end
