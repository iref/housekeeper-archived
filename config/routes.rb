Housekeeper::Application.routes.draw do
  with_options only: [:index, :show, :update] do |list_only|
    list_only.resources :circles
    list_only.resources :users
  end

  get '/user', to: 'users#show'
  patch '/user', to: 'users#update'
end
