# frozen_string_literal: true

SayWhatWhat::Engine.routes.draw do
  scope :publicassets do
    get "styles/:id", to: "public_assets#styles", as: :public_asset_styles
  end

  resources :errors, param: :public_id, only: %i[index show]
end
