class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :website
      t.string :team
      t.integer :rank
      t.integer :week
      t.integer :year
      t.string :description
      t.string :article_link
      t.timestamp :published

      t.timestamps
    end
  end
end
