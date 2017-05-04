class V1::SearchController < ApplicationController
  require "httparty"
  API_URL = "https://api.spotify.com/v1/search?type=artist&limit=#{ENV["ARTISTS_PER_PAGE" || 50]}&q="

  def index
    if has_query?
      fetch_artists
    else
      render json: { message: "Search query string `?q=` expected" },
        status: :expectation_failed
    end
  end

  private

  def has_query?
    params.include?(:q)
  end

  def fetch_artists
    artists = client["artists"]["items"]

    if artists && artists.any?
      render json: { artists: artists.map { |a| ArtistDecorator.new(a).decorate } },
        status: :ok
    else
      render json: { artists: [] },
        status: :partial_content
    end
  end

  def client
    response = HTTParty.get("#{API_URL}#{params[:q]}")
    response.parsed_response
  end
end
