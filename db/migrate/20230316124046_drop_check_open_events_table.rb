class DropCheckOpenEventsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :check_open_events_tables
  end
end
