class CreateCheckOpenEventsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :check_open_events_tables do |t|
      t.timestamps
    end
  end
end
