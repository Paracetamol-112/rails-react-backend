Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :students do
        collection do
          post :batch_create
        end
      end
    end
  end
end