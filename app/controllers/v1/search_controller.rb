class V1::SearchController < ApplicationController
  URL_ORIGIN = "https://api.spotify.com/v1/search?type=artist&limit=#{ENV["ARTISTS_PER_PAGE" || 50]}&q="

  def index
    return :ok
  end
end
