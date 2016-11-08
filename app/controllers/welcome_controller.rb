class WelcomeController < ApplicationController

  http_basic_authenticate_with name: "tcrosley", password: "tmoney"

  # GET /welcome
  def index

  end

end
