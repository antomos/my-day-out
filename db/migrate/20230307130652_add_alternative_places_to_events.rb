class AddAlternativePlacesToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :alternative_places, :jsonb, default: {}
  end
end
