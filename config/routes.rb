Rails.application.routes.draw do
  scope format: true, constraints: { format: 'json' } do
    namespace :api do 
      namespace :v1 do 
       resources :lines, only: [:index, :create]
       post 'user_token' => 'user_token#create'
      end 
    end
  end

  root to: 'pages#home'
end
