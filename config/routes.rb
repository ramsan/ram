Dyr::Application.routes.draw do
  
  get "conform/index"

  resources :posts
  if Rails.env.staging? || Rails.env.development?
    controller :mobile_api do
      
      get "addcoments"
      get "addfavourite"
      get "addmemoriedetails"
      get "B"
      get "GetMemories"
      get "comments"
      get "followuser"
      get "getcategories"
      get "getcomments"
      get "getshowdown"
      get "getuserdetails"
      get "rememberedmemories"
      get "result"
      get "search"
      get "signin"
      get "views"
      get "usercomments"
      get "userfollowedby"
      get "userfollowing"
      get "userrememberedmemories"
      get "emailconform"
      get "index"
      get "conform"
      post "conform"
    end
  end
  
  get "banned/index"
  get "whotofollow/index"

  get "images/destroy"
  get "list/index"

  controller :feeds do
    get "feeds/index"
    get "feeds/next"
    
  end

  resources :categories
  
  resources :votes
  
  resources :visits, :only => :create, :method => :post

  root :to => "home#index"
  controller :home do
    # ONLY FOR TEST EMAILS NOTIFICATIONS TEMPLATE
    # match 'email_test', :via => :get, :path => '/email-test'
    match 'list_view', :via => [:get, :post], :path => "/listing-memories"
    match 'vip', :via => :get, :path => '/VIP_ENTRANCE'
    match 'vip', :via => :get, :path => '/VIP_entrance'
    match 'vip', :via => :get, :path => '/vip_ENTRANCE'
    match 'vip', :via => :get, :path => '/vip_entrance'
    match 'vip', :via => :get, :path => '/preview'
    match 'decade_index', :via => :get
    match 'entrance', :via => [:get, :put]
    match 'birthyear', :via => [:get, :put]
    match 'splash'
    match 'help'
    match 'about'
    match 'terms_of_service'
    match 'privacy_policy'
    match 'get_our_app'
    match 'login_register'
    match 'trending'
    match 'contact_us'
  end
  
  resources :showdowns
  match "/voting/next_vote" => "showdowns#next_vote", :via => :get
  
  
  devise_for :images, :controllers => { :images => "images", :memories => "memories" }, :sign_out_via => [:post, :delete, :get]
  namespace :images do
    match 'edit/:id', :action => :edit, :as => 'edit_images'
    match ':memory_id/:id', :action => :destroy, :as => 'delete_by_images_memory_id'
  end

  devise_for :users, :controllers => { :registrations => "registrations", :passwords => 'passwords', :sessions => 'sessions', :confirmations => "confirmations"}, :sign_out_via => [:post, :delete, :get]
  namespace :users do
    post 'follow'
    match 'unfollow/:followee_id', :action => :unfollow, :as => 'unfollow'
    match 'home'
    match ':id/profile', :action => :profile, :as => 'profile'    
    match 'follow_from_profile/:followee_id', :action => :follow_from_profile, :as => 'follow_from_profile'
    match 'unfollow_from_profile/:followee_id', :action => :unfollow_from_profile, :as => 'unfollow_from_profile'
    match 'follow_from_profile_followers/:followee_id', :action => :follow_from_profile_followers, :as => 'follow_from_profile_followers'
    match 'unfollow_from_profile_followers/:followee_id', :action => :unfollow_from_profile_followers, :as => 'unfollow_from_profile_followers'
    match 'bu/:id', :action => 'become_user', :as => 'b' #convenience method to circumvent FB logins, should never be called by the public
    match 'set_notification/:notification_bit/:new_state', :action => :set_notification, :as => :set_notification
    match 'set_preference/:notification_bit/:new_state', :action => :set_preference, :as => :set_preference
  end
  
  #OmniAuth
  match '/auth/:service/callback' => 'services#create' 
  resources :services, :only => [:index, :create, :destroy]
  
  match '/memories/add-to-memory-bank' => 'memories#add_to_memory_bank', :as => 'add_to_memory_bank'
  match '/memories/my-memory-bank' => 'memories#memory_bank', :as => 'memory_bank'
  match '/memories/:id/send_to_a_friend' => 'memories#send_to_a_friend', :as => 'send_to_a_friend'
  match '/memories/categories/:category_id' => 'memories#per_category', :as => 'memories_per_category'
  match '/memories/decades/:decade_id' => 'memories#per_decade', :as => 'memories_per_decade'
  match '/memories/my-suggested-memories' => 'memories#per_similar_demographics', :as => 'memories_per_similar_demographics'
  match '/memories/birthyear-suggested-memories' => 'memories#by_birthyear', :as => 'by_birthyear'
  resources :memories do
    member do
      match 'also_remembers'
      match 'forgot'
      match 'suspend'
      match 'unsuspend'
      match 'ban_user'
      match 'unban_user'
      # match 'lightbox'
    end
  end
  
  resources :previews, :only => [] do
    member do
      get 'comments'
      get 'related'
      get 'remembered'
      get 'photos'
      get 'post_comment'
      get 'also_remembers'
      get 'forgot'
      get 'follow'
      get 'unfollow'
      get 'delete'
    end
  end
  
  resources :images, :only => [:create, :update, :destroy]
  
  match '/search' => 'search#new'
  match '/search/result' => 'search#result'
  match '/whotofollow/index' => 'whotofollow#index'
  match '/images/memory_id/id' => 'images/:memory_id#:id'

  resources :comments, :only => :create
 
  # API
  namespace :v1 do
    controller :lists do
      match 'categories'
      match 'decades'
    end
    controller :memories do
      match 'memories/:start/:amount', :action => :index
      match 'memories/:start/:amount/decade/:id', :action => :per_decade
      match 'memories/:start/:amount/category/:id', :action => :per_category
      match 'memories/:start/:amount/suggested/:year/:gender', :action => :suggested
      match 'memories/:start/:amount/suggested/:year', :action => :suggested
    end
  end
  
  resources :invitations, :only => [:new, :create]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end