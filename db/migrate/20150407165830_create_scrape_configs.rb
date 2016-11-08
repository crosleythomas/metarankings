class CreateScrapeConfigs < ActiveRecord::Migration
  def change
    create_table :scrape_configs do |t|
      t.string :website
      t.string :url
      t.string :rank_xpath
      t.string :rank_regex
      t.string :team_xpath
      t.string :team_regex
      t.string :description_xpath
      t.string :description_regex
      t.string :update_checker_xpath
      t.string :update_checker_regex
      t.integer :week
      t.integer :year

      t.timestamps
    end
  end
end
