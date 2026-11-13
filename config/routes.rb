# frozen_string_literal: true

SayWhatWhat::Engine.routes.draw do
  scope :publicassets do
    get "styles/:id", to: "public_assets#styles", as: :public_asset_styles
  end

  resources :errors, param: :public_id, only: %i[index show destroy] do
    post 'mark_resolution', to: 'errors#mark_resolution'
    post 'unmark_resolution', to: 'errors#unmark_resolution'
  end
end
