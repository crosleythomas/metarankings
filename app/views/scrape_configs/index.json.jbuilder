json.array!(@scrape_configs) do |scrape_config|
  json.extract! scrape_config, :id, :website, :url, :rank_xpath, :rank_regex, :team_xpath, :team_regex, :description_xpath, :description_regex, :update_checker_xpath, :update_checker_regex, :week, :year
  json.url scrape_config_url(scrape_config, format: :json)
end
