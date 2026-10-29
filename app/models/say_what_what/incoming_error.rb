# frozen_string_literal: true

module SayWhatWhat
  class IncomingError
    def initialize(error:, handled:, severity:, error_context: {})
      @error_class = error.class
      @error_context = error_context
      @message = derive_message(error)
      @backtrace = error.backtrace
      @handled = handled
      @severity = severity
    end

    def finger_print
      @finger_print ||= Digest::SHA256.hexdigest(
        "#{error_class}#{message}#{backtrace[0..2]}"
      )
    end

    def deal_with_it
      @error = Error.find_by(finger_print:)

      update_or_create_error

      error_context[:controller] = error_context[:controller].to_s if error_context[:controller]

      create_occurrence
    rescue StandardError => e
      LOGGER.tagged(SayWhatWhat.name) { LOGGER.error(e) }
      LOGGER.tagged(SayWhatWhat.name) { LOGGER.error("Unable to persist error.") }
    end

    private

    attr_reader :error_class, :message, :backtrace, :handled, :severity, :error_context

    def occurrence_at
      @occurrence_at ||= Time.current
    end

    def update_or_create_error
      if @error.present?
        @error.increment(:occurrence_count)
        @error.last_seen_at = occurrence_at
        @error.save
      else
        @error = Error.create(
          finger_print:, error_class:, message:, backtrace:, last_seen_at: occurrence_at,
          handled:, severity:, occurrence_count: 1, created_at: occurrence_at
        )
      end
    end

    def create_occurrence
      ErrorOccurrence.create(
        say_what_what_error_id: @error.id,
        request_method: error_context[:request_method],
        request_path: error_context[:request_path],
        error_context: error_context,
        created_at: occurrence_at
      )
    end

    def derive_message(error)
      if error_context[:job].present?
        "#{error_context[:job_class]} error"
      else
        error.message
      end
    end
  end
end
