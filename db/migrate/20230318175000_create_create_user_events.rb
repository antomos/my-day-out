class CreateCreateUserEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :create_user_events do |t|

      t.timestamps
    end
  end
end
