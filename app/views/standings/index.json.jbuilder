json.array!(@standings) do |standing|
  json.extract! standing, :id, :team, :week, :year, :wins, :losses, :percentage
  json.url standing_url(standing, format: :json)
end
