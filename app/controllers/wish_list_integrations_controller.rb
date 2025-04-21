class WishListIntegrationsController < ApplicationController

	skip_before_filter :verify_authenticity_token  

	def create_with_list
		app_configuration = AppConfiguration.where(:shop_url => params[:shop_domain]).first
    if not app_configuration.nil?
			shopify_api_key = app_configuration.api_key
			shopify_api_password = app_configuration.api_password
			shopify_api_domain = app_configuration.shop_url
			if params[:variant_id].present?
				if not params[:variant_id].nil?
					if not params[:variant_id].blank?
						variant_id = params[:variant_id]
					else
						variant_id = nil
					end
				else
					variant_id = nil
				end
			else
				variant_id = nil
			end
			if UserWishList.where(:shop_domain => params[:shop_domain], :customer_id => params[:customer_id], :product_id => params[:product_id], :variant_id => variant_id).count == 0
				begin
		      fetch_product = RestClient.get("https://#{shopify_api_key}:#{shopify_api_password}@#{shopify_api_domain}/admin/products/#{params[:product_id]}.json")
					single_product = JSON.parse(JSON.parse(fetch_product.body)["product"].to_json)
					if single_product.nil?
						render json: {}, :status => 200
					else
						begin
							fetch_customer = RestClient.get("https://#{shopify_api_key}:#{shopify_api_password}@#{shopify_api_domain}/admin/customers/#{params[:customer_id]}.json")
							single_customer = JSON.parse(JSON.parse(fetch_customer.body)["customer"].to_json)
							if single_customer.nil?
								render json: {}, :status => 200
							else
								user_wish_list = UserWishList.new
								user_wish_list.shop_domain = params[:shop_domain]
								user_wish_list.product_id = single_product["id"]
								user_wish_list.customer_id = single_customer["id"]
								user_wish_list.customer_email = single_customer["email"]
								user_wish_list.wish_list_date = Time.now
								if not single_customer["default_address"].nil?
									user_wish_list.customer_phone = single_customer["default_address"]["phone"]
									user_wish_list.customer_city = single_customer["default_address"]["city"]
								end
								user_wish_list.customer_name = "#{single_customer['first_name']} #{single_customer['last_name']}"
								user_wish_list.product_title = single_product["title"]
								if single_product["product_type"] == "Simple Product"
									variant = single_product["variants"].first
									user_wish_list.product_sku = variant["sku"]
									user_wish_list.variant_title = variant["title"]
									user_wish_list.barcode = variant["barcode"]
								end							
								if not single_product["image"].nil?
									user_wish_list.product_image = single_product["image"]["src"]
								end
								if params[:variant_id].present?
									if not params[:variant_id].nil?
										if not params[:variant_id].blank?
											single_product["variants"].each do |variant|
												if params[:variant_id] == variant["id"].to_s
													user_wish_list.product_sku = variant["sku"]
													user_wish_list.variant_id = variant["id"]
													user_wish_list.variant_title = variant["title"]
													user_wish_list.barcode = variant["barcode"]
												end
											end
										end
									end
								end
								user_wish_list.save
								render json: {}, :status => 200
							end
						rescue ActiveRecord::RecordNotFound
				      render json: {message: "Customer Not Found"}, :status => 422
				    end
					end
		    rescue ActiveRecord::RecordNotFound
		      render json: {message: "Product Not Found"}, :status => 422
		    end
		  else
		  	render json: {message: "Product Already Added in Wishlist"}, :status => 422
		  end
		else
			render json: {message: "Shop URL is not register"}, :status => 422
		end
	end

	def customer_wish_list_view
		@user_wish_lists = UserWishList.where(:customer_id => params[:customer_id], :shop_domain => params[:shop_domain])
		render status:200, template: 'wish_list_integrations/customer_wish_list_view.json.jbuilder'
	end

	def delete_wish_list
		user_wish_list = UserWishList.where(:id => params[:id], :shop_domain => params[:shop_domain])
		if user_wish_list.count == 1
			user_wish_list.destroy_all
		end
		render json: {}, :status => 204
	end

end
