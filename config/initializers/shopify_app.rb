ShopifyApp.configure do |config|
  config.application_name = "Simply Wish List"
  config.api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  config.secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  config.scope = "read_orders, read_products, read_customers, read_products"
  config.embedded_app = true
end
