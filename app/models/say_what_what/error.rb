module SayWhatWhat
  class Error < ApplicationRecord
    has_many :occurrences,
      class_name: 'SayWhatWhat::ErrorOccurrence',
      foreign_key: 'say_what_what_error_id'

    def to_param
      public_id
    end

    def parsed_backtrace
      JSON.parse(self.backtrace)
    end
  end
end
