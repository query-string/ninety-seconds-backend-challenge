class ArtistMatcherService
  attr_reader :model, :artist_id, :spotify, :error

  def initialize(artist_id)
    @artist_id = artist_id
    @spotify   = SpotifyService.new
  end

  def fetch
    @model = artists.any? ? fetch_existent : fetch_api
  end

  def fetch_existent
    artists.first
  end

  def fetch_api
    if api_request.keys.include?("error")
      @error = {
        error:  { status: 404, message: "Sorry, an artist with defined ID doesn't exist" }
      }
    else
      create_artist api_request
    end
  end

  def artists
    @artists ||= Artist.with_spotify_id(artist_id)
  end

  private

  def api_request
    @api_request ||= spotify.artist(artist_id)
  end

  def create_artist(payload)
    decorated = ArtistDecorator.new(payload).decorate
    Artist.create(spotify_id: decorated["id"], payload: decorated)
  end
end
