class V1::SearchController < ApplicationController
  URL_ORIGIN = "https://api.spotify.com/v1/search?type=artist&limit=#{ENV["ARTISTS_PER_PAGE" || 50]}&q="

  def index
    if has_query?
      head :ok
    else
      render json: { message: "Search query string `?q=` expected" }, status: :expectation_failed
    end
  end

  private

  def has_query?
    params.include?(:q)
  end
end
