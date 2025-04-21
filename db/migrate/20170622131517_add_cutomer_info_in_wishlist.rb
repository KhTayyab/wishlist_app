class AddCutomerInfoInWishlist < ActiveRecord::Migration[5.0]
  def change
  	add_column :user_wish_lists, :customer_phone, :string, :default => ""
		add_column :user_wish_lists, :customer_city, 	:string, :default => ""
  end
end
