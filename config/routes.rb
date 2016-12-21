Rails.application.routes.draw do

  get 'management/index'
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
