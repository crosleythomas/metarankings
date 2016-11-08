json.array!(@keyvals) do |keyval|
  json.extract! keyval, :id, :key, :value
  json.url keyval_url(keyval, format: :json)
end
