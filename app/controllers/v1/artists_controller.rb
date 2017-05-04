class V1::ArtistsController < ApplicationController

  def show
    artists = Artist.by_spotify_id(params[:id])

    if artists.any?
      # @TODO: Keep artists payload updated
      respond_with_artist artists.first.payload
    else
      payload = spotify.artist(params[:id])

      if payload["error"]
        render json: { error: error_message}, status: :not_found
      else
        create_artist(payload)
      end
    end
  end

  private

  def create_artist(payload)
    artist = ArtistDecorator.new(payload).decorate
    respond_with_artist artist
    Artist.create(spotify_id: artist["id"], payload: artist)
  end

  def respond_with_artist(artist)
    render json: artist, status: :ok
  end

  def error_message
    { status: 404, message: "Sorry, an artist with defined ID doesn't exist" }
  end
end
