class StringToText < ActiveRecord::Migration
  def change
  	change_column :ranks, :description, :text
  end
end
