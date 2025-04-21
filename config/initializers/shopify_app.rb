ShopifyApp.configure do |config|
  config.application_name = "Simply Wish List"
  config.api_key = "0c5ee7672aa037e396b19c97ff15ea5e"
  config.secret = "b5b4a0bfd38ed06a74cf01c955102a0b"
  config.scope = "read_orders, read_products, read_customers, read_products"
  config.embedded_app = true
end
