class AddOrdernumberToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :order_number, :string
  end
end
