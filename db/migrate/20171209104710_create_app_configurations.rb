class CreateAppConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :app_configurations do |t|
    	t.string 		:shop_name
    	t.string 		:shop_url
    	t.string 		:actual_shop_url
    	t.string 		:api_key
    	t.string 		:api_password
      t.timestamps
    end
  end
end
