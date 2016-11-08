json.array!(@ranks) do |rank|
  json.extract! rank, :id, :website, :team, :rank, :week, :year, :description, :article_link, :published
  json.url rank_url(rank, format: :json)
end
