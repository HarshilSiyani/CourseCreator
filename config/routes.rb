Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :courses, only: [:new, :create, :show] do
    resources :enrollments, only: [:create]
    resources :study_modules, only: [:new, :create]
  end

  namespace :study do 
    resources :courses, only: [:show] do 
      resource :progress, only: [:create]
    end
  end

  patch '/courses/:id/publish', to: 'courses#publish'

end
