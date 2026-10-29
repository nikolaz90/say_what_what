# frozen_string_literal: true

json.errors @errors do |error|
  json.public_id error.public_id
  json.error_class error.error_class
  json.message error.message
  json.occurrence_count error.occurrence_count
  json.last_seen_at error.last_seen_at
end

json.meta do
  json.page @pagy.page
  json.total @pagy.count
  json.per_page @pagy.in
end
