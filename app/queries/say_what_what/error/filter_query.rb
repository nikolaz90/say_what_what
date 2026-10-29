# frozen_string_literal: true

module SayWhatWhat
  class Error
    class FilterQuery < ApplicationQuery
      def call(options: {})
        @options = prepare_options(options)
        if @options.empty?
          model.all
        elsif needs_occurrences?
          model.joins(:occurrences).where(concatenated_where_clause).distinct
        elsif wider_search?
          model.joins(:occurrences).where([wider_search_clause, { search_term: "%#{@options[:search]}%" }]).distinct
        else
          model.where(concatenated_where_clause).distinct
        end
      end

      def permitted_error_options
        %i[
          error_class message severity occurrence_count
          last_seen_at_from last_seen_at_to resolved_at_from resolved_at_to
          unresolved request_path search
        ]
      end

      private

      def key_to_where_clause(options_key)
        {
          error_class: "say_what_what_errors.error_class ILIKE '%%%s%%'",
          message: "say_what_what_errors.message ILIKE '%%%s%%'",
          severity: "say_what_what_errors.severity = '%s'",
          occurrence_count: "say_what_what_errors.occurrence_count > %i",
          last_seen_at_from: "say_what_what_errors.last_seen_at > '%s'",
          last_seen_at_to: "say_what_what_errors.last_seen_at < '%s'",
          resolved_at_from: "say_what_what_errors.resolved_at > '%s'",
          resolved_at_to: "say_what_what_errors.resolved_at < '%s'",
          unresolved: "say_what_what_errors.resolved_at IS NULL",
          request_path: "say_what_what_error_occurrences.request_path ILIKE '%%%s%%'"
        }[options_key]
      end

      def concatenated_where_clause
        index = 0
        @options.each_with_object(String.new) do |(curr_key, curr_val), acc|
          acc.concat(" AND ") if index.positive?
          acc.concat(key_to_where_clause(curr_key) % curr_val)
          index += 1
        end
      end

      def needs_occurrences?
        @options[:request_path].present?
      end

      def wider_search?
        @options[:search].present?
      end

      def prepare_options(options)
        return {} if options.empty?

        permitted_error_options.each_with_object({}) do |curr, acc|
          next if options[curr].nil? || !options[curr].present?

          acc[curr] = options[curr]
        end
      end

      def wider_search_clause
        <<~SQL.squish
          say_what_what_errors.error_class ILIKE :search_term
          OR
          say_what_what_errors.message ILIKE :search_term
          OR
          say_what_what_error_occurrences.request_path ILIKE :search_term
        SQL
      end
    end
  end
end
