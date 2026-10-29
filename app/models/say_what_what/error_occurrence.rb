# frozen_string_literal: true

module SayWhatWhat
  class ErrorOccurrence < ApplicationRecord
    belongs_to :error,
               class_name: "SayWhatWhat::Error",
               foreign_key: "say_what_what_error_id"
  end
end
