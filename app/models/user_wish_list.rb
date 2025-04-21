class UserWishList < ApplicationRecord

	# after_create :send_user_email

	# def send_user_email
	# 	Thread.new do
	# 		UserMailer.user_wishlist(self.customer_email, "SapphireOnline Wishlist", self, "", "").deliver
	# 	end
	# end

	# UserWishList.store_wish_list_reports
	def self.store_wish_list_reports
		
		Shop.all.each do |store_shop|
			app_configuration = AppConfiguration.where(:shop_url => store_shop.shopify_domain).first
			if not app_configuration.nil?
				if not app_configuration.to_email_address.blank?
					time = Time.now - 1.day
					email_date = time.to_date.strftime('%d-%m-%Y')

					shopify_store_domain = store_shop.shopify_domain
					start_date = time
					end_date = time

					@wish_lists = UserWishList.where(:shop_domain => shopify_store_domain, :wish_list_date => start_date.to_date.beginning_of_day..end_date.to_date.end_of_day).order("id DESC")
					xlsx = Axlsx::Package.new

					color_array = []
					xlsx.workbook.add_worksheet(:name => "Wish List Report") do |sheet|

						sheet.add_row
						Array.new(100).each_index do |index|
					  	sheet.rows[0].add_cell("")
					  	sheet.column_info[index].width = 30
					  end

						blue_and_white_format = sheet.styles.add_style(:bg_color => "00456e", :fg_color=> "ffffff", :sz => 8,  :border=> {:style => :thin, :color => "000000"}, :alignment => { :horizontal => :center, :vertical => :center}, b: true)
						line_item_format = sheet.styles.add_style(:num_fmt => 3, :bg_color => "ffffff", :fg_color=> "641E16", :sz => 8,  :border=> {:style => :thin, :color => "000000"}, :alignment => { :horizontal => :center, :vertical => :center}, b: true)
				  	category_format = sheet.styles.add_style(:num_fmt => 3, :bg_color => "ffffff", :fg_color=> "154360", :sz => 8,  :border=> {:style => :thin, :color => "000000"}, :alignment => { :horizontal => :center, :vertical => :center}, b: true)

						color_array = [blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format, blue_and_white_format]
					  sheet.add_row ["Sr #", "Product Title", "Product SKU", "Barcode", "Customer Email", "Customer Name", "Customer Phone", "Customer City", "Date"], :style => color_array
					  row_count = 1

					  @wish_lists.each do |wish_list|
					  	color_data_array = []
					  	if row_count.even?
					  		color_data_array = [line_item_format, line_item_format, line_item_format, line_item_format, line_item_format, line_item_format, line_item_format, line_item_format]
					  	else
					  		color_data_array = [category_format, category_format, category_format, category_format, category_format, category_format, category_format, category_format]
					  	end
					  	sheet.add_row [row_count, wish_list.product_title, wish_list.product_sku, wish_list.barcode, wish_list.customer_email, wish_list.customer_name, wish_list.customer_phone, wish_list.customer_city, wish_list.wish_list_date.strftime("%d-%m-%Y")], :style => color_data_array
					  	row_count = row_count + 1
					  end
					  
					end

					excel_start_date = start_date.to_date.strftime('%m-%d-%Y')
					excel_end_date = end_date.to_date.strftime('%m-%d-%Y')

					file_name = "/excel/wish_list-#{excel_start_date}-#{time.to_i}.xlsx"
					report_file_name = "wish_list-#{excel_start_date}-#{time.to_i}.xlsx"
					xlsx.serialize "#{Rails.public_path}#{file_name}"
					s3_file_name = "#{Rails.public_path}#{file_name}"

			    s3 = Aws::S3::Resource.new(
			      credentials: Aws::Credentials.new(Rails.application.secrets.aws_access_key, Rails.application.secrets.aws_secret_key),
			      region: 'us-east-1'
			    )

			    obj = s3.bucket(Rails.application.secrets.aws_bucket).object("wish_list_report/#{report_file_name}")
			    obj.upload_file s3_file_name, {acl: 'public-read'}
			    obj.public_url

			    url_path = obj.public_url

			    max_retries = 3
			  	times_retried = 0

			  	begin
			    	UserMailer.send_report("#{app_configuration.to_email_address}", "#{shopify_store_domain.split('.')[0].titleize} Store Daily Wish List Report As on Date #{email_date}", "#{shopify_store_domain.split('.')[0].titleize} Online Store Daily Wish List Report As on Date #{email_date}", url_path, "#{app_configuration.cc_email_address}", "khawajatayyab@icloud.com").deliver
			  	rescue Net::ReadTimeout => error
				    if times_retried < max_retries
				      times_retried += 1
				      puts "\n\nFailed to <do the thing>, retry #{times_retried}/#{max_retries}\n\n"
				      retry
				    else
				      puts "\n\nExiting script. File URL: #{url_path}\n\n"
				      exit(1)
				    end
				  end
				end
			end
		end
	end

	# UserWishList.pk_restock_email
	def self.pk_restock_email
		shopify_api_key = "c92d55855b0e93407a5fe425cf7da2e0"
		shopify_api_password = "265e91c2d06673a967a7f7902866459d"
		shopify_api_domain = "sapphire-online.myshopify.com"
		shop = "sapphire-online.myshopify.com"
		wish_lists = UserWishList.where(:shop_domain => shop, :is_restock => false).order("id DESC")

		wish_lists.each do |user_wish_list|
			begin
	      fetch_product = RestClient.get("https://#{shopify_api_key}:#{shopify_api_password}@#{shopify_api_domain}/admin/products/#{user_wish_list.product_id}.json")
				single_product = JSON.parse(JSON.parse(fetch_product.body)["product"].to_json)
				if not single_product.nil?
					if single_product["product_type"] == "Simple Product"
						variant = single_product["variants"].first
						if variant["inventory_quantity"].to_i > 0
							# Thread.new do
								UserMailer.restock_wishlist(user_wish_list.customer_email, "SapphireOnline Wishlist Product Back in Stock", user_wish_list, "", "").deliver
							# end
							user_wish_list.is_restock = true
							user_wish_list.save
						end
					else
						variants = single_product["variants"]
						variants.each do |variant|
							if variant["sku"] == user_wish_list.product_sku
								if variant["inventory_quantity"].to_i > 0
									# Thread.new do
										UserMailer.restock_wishlist(user_wish_list.customer_email, "SapphireOnline Wishlist Product Back in Stock", user_wish_list, "", "").deliver
									# end
									user_wish_list.is_restock = true
									user_wish_list.save
								end	
							end
						end
					end							
				end
			rescue ActiveRecord::RecordNotFound
			end
		end
	end

end
