json.array!(@images) do |image|
  json.extract! image, :id, :team_name, :url
  json.url image_url(image, format: :json)
end
