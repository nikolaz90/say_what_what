module SayWhatWhat
  class ErrorsController < ApplicationController
    def index
      collection = filter_query.call(options: index_filter_params)
      @pagy, @errors = pagy(:offset, collection.order(last_seen_at: :desc))
      respond_to do |format|
        format.html
        format.json
      end
    end

    def show
      @error = SayWhatWhat::Error.find_by(public_id: params[:public_id])
      respond_to do |format|
        format.html
        format.json
      end
    end

    private

    def filter_query
      @filter_query ||= SayWhatWhat::Error::FilterQuery.new
    end

    def index_filter_params
      params.permit(*filter_query.permitted_error_options)
    end
  end
end
