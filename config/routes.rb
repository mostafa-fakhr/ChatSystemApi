Rails.application.routes.draw do
  # Resourceful routes for applications, chats, and messages
  resources :applications, param: :token, only: [:create, :update, :show, :index] do
    resources :chats, param: :number, only: [:create, :show, :index, :update] do
      resources :messages, param: :number, only: [:create, :show, :index, :update] do
        # For Elastic Search
        collection do
          get 'search'
        end
      end
    end
  end
end
