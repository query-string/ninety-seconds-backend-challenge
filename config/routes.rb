Rails.application.routes.draw do
  namespace :v1 do
    resources :search, only: :index
  end
end
