class AddShareTokenToItineraries < ActiveRecord::Migration[7.0]
  def change
    add_column :itineraries, :share_token, :string
    add_index :itineraries, :share_token
  end
end
