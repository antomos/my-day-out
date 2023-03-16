class DropCheckOpenNowsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :check_open_nows
  end
end
