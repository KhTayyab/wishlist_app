json.wish_lists @user_wish_lists.each do |wish_list|
  json.id wish_list.id  
  json.product_image wish_list.product_image
  json.product_title wish_list.product_title
  json.barcode 			 wish_list.barcode
  json.product_sku wish_list.product_sku
  json.customer_email wish_list.customer_email
  json.customer_name wish_list.customer_name
  json.date_time wish_list.wish_list_date.strftime("%d-%m-%Y")
end