ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'


  # RailsCoders routes
  map.index '/', :controller => 'pages', 
                 :action => 'show', 
                 :id => '1-welcome-page'

  map.resources :pages
  map.resources :users, :member => { :enable => :put } do |users|
    users.resources :roles
  end

  map.resources :articles, :collection => {:admin => :get}

  map.resources :categories, :collection => {:admin => :get} do |categories|
    categories.resources :articles, :name_prefix => 'category_'
  end
  

  map.show_user '/user/:username', 
                 :controller => 'users', 
                 :action => 'show_by_username'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
