class AddDirectionsToEventToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :directions_to_event, :jsonb, default: {}
  end
end
