# frozen_string_literal: true

module SayWhatWhat
  class ErrorSubscriber
    def report(error, handled:, severity:, context:, source: nil)
      incoming_error = IncomingError.new(error:, handled:, severity:, error_context: context)
      incoming_error.deal_with_it
    end
  end
end
