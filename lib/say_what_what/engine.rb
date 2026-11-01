# frozen_string_literal: true

module SayWhatWhat
  class Engine < ::Rails::Engine
    isolate_namespace SayWhatWhat
    initializer "say_what_what.subscribe_errors" do
      Rails.error.subscribe(::SayWhatWhat::ErrorSubscriber.new) if ::SayWhatWhat.active && !Rails.env.test?
    end
  end
end
