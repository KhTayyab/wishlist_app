class AddEmailsInAppAppConfigurations < ActiveRecord::Migration[5.0]
  def change
  	add_column :app_configurations, :to_email_address, :string, :default => ""
  	add_column :app_configurations, :cc_email_address, :string, :default => ""
  end
end
