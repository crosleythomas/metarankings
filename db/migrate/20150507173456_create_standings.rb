class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.string :team
      t.integer :week
      t.integer :year
      t.integer :wins
      t.integer :losses
      t.float :percentage

      t.timestamps
    end
  end
end
