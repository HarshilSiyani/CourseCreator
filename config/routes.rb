Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :courses, except: [:edit, :index, :destroy, :update] do
    resources :enrollments, only: :create
    resources :module, only: [:new, :create]
  end

  patch '/courses/:id/publish', to: 'courses#publish'

end
