json.array!(@publish_checkers) do |publish_checker|
  json.extract! publish_checker, :id, :website, :publish_tok, :week, :year
  json.url publish_checker_url(publish_checker, format: :json)
end
