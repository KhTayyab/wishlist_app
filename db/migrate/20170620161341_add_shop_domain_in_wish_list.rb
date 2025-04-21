class AddShopDomainInWishList < ActiveRecord::Migration[5.0]
  def change
  	add_column :user_wish_lists, :shop_domain, :string
  end
end
