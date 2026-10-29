# frozen_string_literal: true

module SayWhatWhat
  class ApplicationController < ActionController::Base
    include Pagy::Method
  end
end
