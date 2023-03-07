class CreatePopulateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :populate_events do |t|

      t.timestamps
    end
  end
end
