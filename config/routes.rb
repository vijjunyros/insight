ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.resources :products
    admin.resources :issue_categories
    admin.resources :articles
    admin.resources :article_categories
  end
  
  map.resources :issues do |issue|
    issue.resources :comments,
      :controller => "issue_comments"
  end
  
  map.namespace :api do |api|
    api.resources :issues,
      :collection => { :my => :get, :latest => :get },
      :except     => [ :destroy ] do |issue|
        issue.resources :comments
      end
      
    api.resources :categories do |category|
      category.resources :issues,
        :except => [ :destroy ]
      end
    
    api.resources :leads,    :only => [ :create ]
    api.resources :accounts, :only => [ :create, :update ]
    api.resources :contacts, :only => [ :create, :update ],
      :collection => { :email => :get }
    api.resources :articles,
      :collection => { :latest => :get }
    api.resources :article_categories
  end
  
end