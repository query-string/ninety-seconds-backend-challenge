class ApplicationController < ActionController::API
  def spotify
    SpotifyService.new
  end
end
