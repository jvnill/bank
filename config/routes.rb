Rails.application.routes.draw do
  resources :connected_apps, only: %i[index new create destroy] do
    get :download, on: :member
  end

  root 'connected_apps#index'
end
