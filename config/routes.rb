# frozen_string_literal: true

SayWhatWhat::Engine.routes.draw do
  get "errors", to: "errors#index", as: "say_what_what_errors"
  get "errors/:public_id", to: "errors#show", param: :public_id, as: "say_what_what_error"

  scope :publicassets do
    get "styles/:id", to: "public_assets#styles", as: :public_asset_styles
  end
  # resources :say_what_what_errors, param: :public_id, only: %i[index show]
end
