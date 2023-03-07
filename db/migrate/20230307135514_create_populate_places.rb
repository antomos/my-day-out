class CreatePopulatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :populate_places do |t|

      t.timestamps
    end
  end
end
