Rails.application.routes.draw do

	scope "(:locale)", locale: /en|es/ do
	  get 'management/index'
	  get 'management/template'
	  post 'management/import'
	  post 'management/backup'
	  post 'management/restore'
	
	  get 'reports/index'
	  get 'reports/monthly'
	  get 'reports/yearly'
	  get 'reports/originsByCategory'
	
	  get 'welcome/index'
	
	  root 'welcome#index'
	
	  devise_for :users
	  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
	end
 
end
