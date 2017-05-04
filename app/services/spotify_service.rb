class SpotifyService
  require "httparty"

  BASE_URL = "https://api.spotify.com/v1"
  attr_reader :search_endpoint, :artists_endpoint

  def initialize
    @search_endpoint  = "#{BASE_URL}/search?type=artist&limit=#{ENV["ARTISTS_PER_PAGE" || 50]}&q="
    @artists_endpoint = "#{BASE_URL}/artists"
  end

  def search(query)
    hit_api "#{search_endpoint}#{query}"
  end

  def artist(artist)
    hit_api "#{artists_endpoint}/#{artist}"
  end

  private

  def hit_api(url)
    response = HTTParty.get(url)
    response.parsed_response
  end
end
