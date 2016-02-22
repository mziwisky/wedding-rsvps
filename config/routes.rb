Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :invitations, path: '/', only: [:show, :update] do
    get '*path' => 'invitations#show' # allow "vanity" urls
  end
  root 'root#index'
end
