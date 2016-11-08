require 'test_helper'

class PublishCheckersControllerTest < ActionController::TestCase
  setup do
    @publish_checker = publish_checkers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:publish_checkers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create publish_checker" do
    assert_difference('PublishChecker.count') do
      post :create, publish_checker: { publish_tok: @publish_checker.publish_tok, website: @publish_checker.website, week: @publish_checker.week, year: @publish_checker.year }
    end

    assert_redirected_to publish_checker_path(assigns(:publish_checker))
  end

  test "should show publish_checker" do
    get :show, id: @publish_checker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @publish_checker
    assert_response :success
  end

  test "should update publish_checker" do
    patch :update, id: @publish_checker, publish_checker: { publish_tok: @publish_checker.publish_tok, website: @publish_checker.website, week: @publish_checker.week, year: @publish_checker.year }
    assert_redirected_to publish_checker_path(assigns(:publish_checker))
  end

  test "should destroy publish_checker" do
    assert_difference('PublishChecker.count', -1) do
      delete :destroy, id: @publish_checker
    end

    assert_redirected_to publish_checkers_path
  end
end
