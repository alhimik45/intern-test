class AddProToProduct < ActiveRecord::Migration
  def change
    add_column :products, :pro, :boolean
  end
end
