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
  mattr_accessor :exempt_path_matchers, default: []
  mattr_accessor :exempt_error_class_matchers, default: []
  mattr_accessor :max_occurrences_per_error, default: nil

  class << self
    def configuration
      yield self
    end
  end
end
