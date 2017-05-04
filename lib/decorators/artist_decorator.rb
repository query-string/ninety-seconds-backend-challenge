class ArtistDecorator
  WHITESPACED_ATTRIBUTES = %w(id external_urls genres href name)
  attr_reader :artist

  def initialize(artist)
    @artist = artist
  end

  def decorate
    artist.select { |k, v| WHITESPACED_ATTRIBUTES.include?(k) }
  end
end
