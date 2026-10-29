# frozen_string_literal: true

module SayWhatWhat
  module Contextable
    def prepare_controller_error_context
      Rails.error.set_context(
        request_params: request.params,
        request_method: request.method,
        request_path: request.path
      )
    end

    def prepare_job_error_context
      Rails.error.set_context(job_class: self.class.name, arguments: self.arguments)
    end
  end
end
