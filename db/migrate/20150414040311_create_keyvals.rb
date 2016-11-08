class CreateKeyvals < ActiveRecord::Migration
  def change
    create_table :keyvals do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
