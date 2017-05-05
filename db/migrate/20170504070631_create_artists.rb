class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    enable_extension "pgcrypto"

    create_table :artists, id: :uuid do |t|
      t.string :spotify_id, uniq: true, null: false
      t.jsonb :payload
      t.boolean :is_favourite, default: false

      t.timestamps
      t.index :spotify_id
    end
  end
end
