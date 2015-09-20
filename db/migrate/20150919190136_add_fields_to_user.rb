class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :avatar, :string
    add_column :users, :passport, :string
    add_column :users, :birthday, :date
    add_column :users, :shopname, :string
  end
end
