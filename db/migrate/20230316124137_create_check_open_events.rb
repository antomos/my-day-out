class CreateCheckOpenEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :check_open_events do |t|
      t.timestamps
    end
  end
end
