class CreateTestEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :test_events do |t|
      t.string :title
      t.string :description
      t.string :address
      t.integer :duration
      t.string :image_url

      t.timestamps
    end
  end
end
