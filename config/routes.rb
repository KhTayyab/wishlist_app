Rails.application.routes.draw do
  root :to => 'wish_lists#index'
  mount ShopifyApp::Engine, at: '/'
  resources :app_configurations, :except => [:new, :create, :destroy, :show]
  resources :wish_list_integrations, :except => [:edit, :update, :destroy, :show, :new, :create, :index] do
  	collection do
  		post    :create_with_list
      get     :customer_wish_list_view
      delete  :delete_wish_list
  	end
  end
  resources :wish_lists, :except => [:edit, :update, :destroy, :show, :new, :create] do
  	collection do
  		get       :wish_list_by_customer
			get 	    :wish_list_by_product
      delete    :remove_wishlist_item
      delete    :remove_customer_wishlist_item
      delete    :remove_product_wishlist_item
  	end
  end
  resources :wish_list_reports, :except => [:edit, :update, :destroy, :show, :new, :create] do
  	collection do
  		get 	:excel_report
  	end
  end
end
