class V1::ArtistsController < ApplicationController
  require "httparty"
  API_URL = "https://api.spotify.com/v1/artists/"

  def show
    artists = Artist.by_spotify_id(params[:id])

    if artists.any?
      # @TODO: Keep artists payload updated
      respond_with_artist artists.first.payload
    else
      response = client
      unless response["error"]
        artist = ArtistDecorator.new(response).decorate
        respond_with_artist artist
        Artist.create(spotify_id: artist["id"], payload: artist)
      else
        render json: { error: { status: 404, message: "Sorry, an artist with defined ID doesn't exist" }},
          status: :not_found
      end
    end
  end

  private

  def client
    response = HTTParty.get("#{API_URL}#{params[:id]}")
    response.parsed_response
  end

  def respond_with_artist(artist)
    render json: artist,
      status: :ok
  end
end
