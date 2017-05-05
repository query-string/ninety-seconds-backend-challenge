class Artist < ApplicationRecord
  scope :with_spotify_id, ->(spotify_id) { where("spotify_id = ?", spotify_id) }
  validates :spotify_id, presence: true, uniqueness: true
end
