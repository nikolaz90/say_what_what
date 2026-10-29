# frozen_string_literal: true

module SayWhatWhat
  class ApplicationQuery
    attr_reader :model

    def initialize(model: self.class.name.constantize.query_model, **_kwargs)
      @model = model
    end

    def self.query_model
      raise NotImplementedError if name == "ApplicationQuery"

      name.sub(/::[^:]{1,}$/, "").constantize
    end
  end
end
