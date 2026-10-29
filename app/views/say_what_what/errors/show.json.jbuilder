json.error do
  json.public_id @error.public_id
  json.error_class @error.error_class
  json.message @error.message
  json.occurrence_count @error.occurrence_count
  json.occurrences do
    @error.occurrences.each do |error_occurrence|
      json.occurred_at error_occurrence.created_at
      json.path error_occurrence.request_path
      json.request_method error_occurrence.request_method
      if error_occurrence.error_context.any?
        json.error_context error_occurrence.error_context
      end
      json.backtrace @error.parsed_backtrace
    end
  end
end
