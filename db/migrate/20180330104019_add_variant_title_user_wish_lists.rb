class AddVariantTitleUserWishLists < ActiveRecord::Migration[5.0]
  def change
  	add_column :user_wish_lists, :variant_title, 	:string, :default => ""
		add_column :user_wish_lists, :barcode, 				:string, :default => ""
  end
end
