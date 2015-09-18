class AddProductsToUser < ActiveRecord::Migration
  def change
    add_reference :users, :products, index: true, foreign_key: true
  end
end
