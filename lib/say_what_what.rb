# frozen_string_literal: true

require "rails/all"
require "say_what_what/version"
require "say_what_what/engine"

require "say_what_what/error_subscriber"
require "say_what_what/generators/say_what_what/install_generator"

require "pagy"

module SayWhatWhat
  LOGGER = ActiveSupport::TaggedLogging.new(Logger.new($stdout))

  mattr_accessor :active, default: false
  mattr_accessor :default_context, default: {}

  class << self
    def configuration
      yield self
    end
  end
end
