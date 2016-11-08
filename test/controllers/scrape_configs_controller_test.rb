require 'test_helper'

class ScrapeConfigsControllerTest < ActionController::TestCase
  setup do
    @scrape_config = scrape_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scrape_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scrape_config" do
    assert_difference('ScrapeConfig.count') do
      post :create, scrape_config: { description_regex: @scrape_config.description_regex, description_xpath: @scrape_config.description_xpath, rank_regex: @scrape_config.rank_regex, rank_xpath: @scrape_config.rank_xpath, team_regex: @scrape_config.team_regex, team_xpath: @scrape_config.team_xpath, update_checker_regex: @scrape_config.update_checker_regex, update_checker_xpath: @scrape_config.update_checker_xpath, url: @scrape_config.url, website: @scrape_config.website, week: @scrape_config.week, year: @scrape_config.year }
    end

    assert_redirected_to scrape_config_path(assigns(:scrape_config))
  end

  test "should show scrape_config" do
    get :show, id: @scrape_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scrape_config
    assert_response :success
  end

  test "should update scrape_config" do
    patch :update, id: @scrape_config, scrape_config: { description_regex: @scrape_config.description_regex, description_xpath: @scrape_config.description_xpath, rank_regex: @scrape_config.rank_regex, rank_xpath: @scrape_config.rank_xpath, team_regex: @scrape_config.team_regex, team_xpath: @scrape_config.team_xpath, update_checker_regex: @scrape_config.update_checker_regex, update_checker_xpath: @scrape_config.update_checker_xpath, url: @scrape_config.url, website: @scrape_config.website, week: @scrape_config.week, year: @scrape_config.year }
    assert_redirected_to scrape_config_path(assigns(:scrape_config))
  end

  test "should destroy scrape_config" do
    assert_difference('ScrapeConfig.count', -1) do
      delete :destroy, id: @scrape_config
    end

    assert_redirected_to scrape_configs_path
  end
end
