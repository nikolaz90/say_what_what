# frozen_string_literal: true

module SayWhatWhat
  class Engine < ::Rails::Engine
    isolate_namespace SayWhatWhat
    initializer "say_what_what.subscribe_errors" do
      if ::SayWhatWhat.active && !Rails.env.test?
        Rails.error.subscribe(::SayWhatWhat::ErrorSubscriber.new)
        ::SayWhatWhat::LOGGER.info("SayWhatWhat::ErrorSubscriber is subscribed to Rails.error")
      end
    end
  end
end
