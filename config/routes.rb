Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :courses, except: [:index, :destroy, :update] do
    resources :enrollments, only: :create
    resources :study_modules, only: [:new, :create]
    resources :lessons, only: [:new, :create, :show, :edit, :update]
    resources :quizzes, only: [:new, :create, :show, :edit, :update]
  end

  resources :users, only: :show do
    resources :enrollments, only: :index
    resources :courses, only: :index
  end

  patch '/courses/:id/publish', to: 'courses#publish'

  namespace :study do
    resources :courses, only: :show
    resources :progresses, only: :create
  end


end
