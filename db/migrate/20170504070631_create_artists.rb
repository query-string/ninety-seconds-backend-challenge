class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    enable_extension "pgcrypto"
    
    create_table :artists, id: :uuid do |t|
      t.integer :spotify_id
      t.jsonb :payload

      t.timestamps
    end
  end
end
