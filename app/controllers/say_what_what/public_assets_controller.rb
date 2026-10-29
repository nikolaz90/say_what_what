# frozen_string_literal: true

module SayWhatWhat
  class PublicAssetsController < ApplicationController
    # before_action { expires_in 1.year, public: true }

    PUBLICASSETS = {
      "css" => {
        "globals" => Engine.root.join("app/public_assets/say_what_what/globals.css")
      }
    }.freeze

    def styles
      render file: PUBLICASSETS.dig(params[:format], params[:id])
    end
  end
end
