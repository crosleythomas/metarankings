class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :team_name
      t.string :url

      t.timestamps
    end
  end
end
