# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'main#index'

  get 'product_variants', to: 'product_variants#index'
end
