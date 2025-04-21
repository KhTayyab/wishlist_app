class WishListsController < ApplicationController

	def index
    # if params[:shop].present?
    #   if params[:shop].blank?
    #     redirect_to("http://www.google.com/")
    #   else
    #     @wish_lists = UserWishList.paginate(:page => params[:page], :per_page => 30).where(:shop_domain => params[:shop]).order("id DESC")
    #   end
    # else
    #   redirect_to("http://www.google.com/")
    # end
    @wish_lists = UserWishList.paginate(:page => params[:page], :per_page => 30).where(:shop_domain => params[:shop]).order("id DESC")
    # @wish_lists = UserWishList.paginate(:page => params[:page], :per_page => 30).order("id DESC")
  end

  def wish_list_by_customer
    @wish_lists = UserWishList.paginate(:page => params[:page], :per_page => 30).where(:shop_domain => params[:shop], :customer_id => params[:customer_id]).order("id DESC")
    # @wish_lists = UserWishList.paginate(:page => params[:page], :per_page => 30).where(:customer_id => params[:customer_id]).order("id DESC")
  end

  def wish_list_by_product
  	@wish_lists = UserWishList.paginate(:page => params[:page], :per_page => 30).where(:shop_domain => params[:shop], :product_id => params[:product_id]).order("id DESC")
    # @wish_lists = UserWishList.paginate(:page => params[:page], :per_page => 30).where(:product_id => params[:product_id]).order("id DESC")
  end

  def remove_wishlist_item
    wish_list = UserWishList.find(params[:id])
    wish_list.destroy
    flash[:success] = "Deleted Successfully"
    redirect_to :back
  end

  def remove_customer_wishlist_item
    wish_list = UserWishList.find(params[:id])
    wish_list.destroy
    flash[:success] = "Deleted Successfully"
    redirect_to :back
  end

  def remove_product_wishlist_item
    wish_list = UserWishList.find(params[:id])
    wish_list.destroy
    flash[:success] = "Deleted Successfully"
    redirect_to :back
  end

end