Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :courses, except: [:index, :destroy, :update] do
    resources :enrollments, only: :create
    resources :study_modules, only: [:new, :create]
    resources :lessons, only: [:new, :create, :show, :edit, :update, :destroy]
    resources :quizzes, only: [:new, :create, :show, :update]
    get :publish, on: :member
  end

  resources :users, only: :show do
    resources :enrollments, only: :index
    resources :courses, only: :index
  end

  patch '/courses/:id/publish', to: 'courses#publish'

  namespace :study do
    resources :courses, only: [:show]
    get 'progresses/:course_id', to: 'progresses#show', as: :current_progress
  end

  get '/quizzes/:id/answers', to: 'quizzes#answers', as: :quiz_answers
  resources :youtube, only: :show

  namespace :chat do
    resources :courses, only: :show do
    # chat_course GET    /chat/courses/:id          chat/courses#show
      resources :messages, only: :create
      # chat_course_messages POST   /chat/courses/:course_id/messages         chat/messages#create
    end
  end
end

