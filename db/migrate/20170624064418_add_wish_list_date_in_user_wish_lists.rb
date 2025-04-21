class AddWishListDateInUserWishLists < ActiveRecord::Migration[5.0]
  def change
  	add_column :user_wish_lists, :wish_list_date, :datetime
  end
end
