class V1::SearchController < ApplicationController

  def index
    if params.include?(:q)
      fetch_artists
    else
      render json: { error: error_message }, status: :expectation_failed
    end
  end

  private

  def fetch_artists
    artists = spotify.search(params[:q])["artists"]["items"]

    if artists && artists.any?
      render json: { artists: artists.map { |a| ArtistDecorator.new(a).decorate } },
        status: :ok
    else
      render json: { artists: [] },
        status: :partial_content
    end
  end

  def error_message
    { status: 412, message: "Search query string `?q=` expected" }
  end
end
