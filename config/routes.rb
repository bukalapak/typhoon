# frozen_string_literal: true

Rails.application.routes.draw do
  resources :jmxs
  resources :load_tests
  resources :master_configurations
  resources :slave_servers

  post "/jmxs/delete", to: "jmxs#destroy"
  post "/jmeters/start", to: "jmeters#start"
  post "/jmeters/stop", to: "jmeters#stop"

  get "homepage/index"

  root "homepage#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
