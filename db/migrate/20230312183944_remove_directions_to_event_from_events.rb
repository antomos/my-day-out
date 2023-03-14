class RemoveDirectionsToEventFromEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :directions_to_event, :string
  end
end
