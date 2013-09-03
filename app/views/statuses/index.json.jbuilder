json.array!(@statuses) do |status|
  json.extract! status, :content
  json.url status_url(status, format: :json)
end
