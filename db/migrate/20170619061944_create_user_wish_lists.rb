class CreateUserWishLists < ActiveRecord::Migration[5.0]
  def change
    create_table :user_wish_lists do |t|
    	t.string 		:customer_id
    	t.string 		:product_id
    	t.string 		:variant_id
    	t.string		:customer_email
    	t.string		:customer_name
    	t.string		:product_title
    	t.string		:product_sku
    	t.string		:product_image
      t.timestamps
    end
  end
end
