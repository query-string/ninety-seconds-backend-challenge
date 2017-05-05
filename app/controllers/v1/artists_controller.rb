class V1::ArtistsController < ApplicationController
  def show
    with_artist do |artist|
      render json: artist.model.payload, status: :ok
    end
  end

  def update
    with_artist do |artist|
      artist.model.update(is_favourite: !artist.model.is_favourite)
      render json: { favourite: artist.model.is_favourite, artist: artist.model.payload }, status: :ok
    end
  end

  private

  def with_artist
    artist = ArtistMatcherService.new(params[:id])
    artist.fetch

    if artist.error
      render json: artist.error, status: :not_found
    else
      yield(artist)
    end
  end
end
