TpTheme::Application.routes.draw do

  root :to => 'Tweets#index'

  resources :tweets, :only => [:index, :show]

  resource :user_session, :only => [:new, :create, :destroy]

  resource :user, :only => [:new, :create, :show, :edit, :update]

  namespace :admin do |admin|
    resources :users
  end

  if Rails.env.test?
    # Make routes for actions whose sole purpose is to test various
    # methods that are in ApplicationController for use by other controllers

    for helper in %w(require_user require_admin require_no_user
                                                      save_notify_and_redirect)
      match "/#{helper}" => "application_controller_test##{helper}_test"
    end
  end
end
