# frozen_string_literal: true

module SayWhatWhat
  class ErrorsController < ApplicationController
    before_action :set_error, only: %i[show destroy mark_resolution unmark_resolution]

    def index
      collection = filter_query.call(options: index_filter_params)
      @pagy, @errors = pagy(:offset, collection.order(last_seen_at: :desc))
      respond_to do |format|
        format.html
        format.json
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json
      end
    end

    def destroy
      @error.occurrences.in_batches(of: 100).delete_all
      @error.destroy
      redirect_to errors_path
    end

    def mark_resolution
      return unless @error.resolved_at.nil?

      @error.update(resolved_at: Time.current)
      redirect_to error_path(@error)
    end

    def unmark_resolution
      return if @error.resolved_at.nil?

      @error.update(resolved_at: nil)
      redirect_to error_path(@error)
    end

    def mark_all_resolution
      collection = filter_query.call(
        options: index_filter_params
      ).where("resolved_at IS NULL").where(created_at: ..time_form_was_loaded)

      collection.in_batches(of: 500) do |batch|
        batch.where("resolved_at IS NULL").update_all(resolved_at: unified_request_time)
      end

      render json: { location: errors_path(index_filter_params.except(:form_loaded_at)) }
    end

    private

    def filter_query
      @filter_query ||= SayWhatWhat::Error::FilterQuery.new
    end

    def index_filter_params
      params.permit(:form_loaded_at, *filter_query.permitted_error_options)
    end

    def set_error
      public_id = params[:public_id] || params[:error_public_id]
      @error = SayWhatWhat::Error.find_by(public_id:)
    end

    def unified_request_time
      @unified_request_time ||= Time.current
    end

    def time_form_was_loaded
      epoch = params[:form_loaded_at].to_i
      epoch ||= Time.now.to_i
      Time.at(epoch.div(1000))
    end
  end
end
