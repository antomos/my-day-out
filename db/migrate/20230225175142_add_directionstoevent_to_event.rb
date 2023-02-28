class AddDirectionstoeventToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :directions_to_event, :string
  end
end
