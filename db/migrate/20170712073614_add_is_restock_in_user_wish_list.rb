class AddIsRestockInUserWishList < ActiveRecord::Migration[5.0]
  def change
  	add_column :user_wish_lists, :is_restock, :boolean, :default => false
  end
end
