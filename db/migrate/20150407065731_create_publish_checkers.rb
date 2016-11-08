class CreatePublishCheckers < ActiveRecord::Migration
  def change
    create_table :publish_checkers do |t|
      t.string :website
      t.string :publish_tok
      t.integer :week
      t.integer :year

      t.timestamps
    end
  end
end
