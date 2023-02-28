class ChangeColumnDatatypes < ActiveRecord::Migration[7.0]
  def change
    change_column :places, :search_rating, :integer, using: 'search_rating::integer'
    change_column :places, :search_user_ratings_total, :integer, using: 'search_user_ratings_total::integer'
    change_column :places, :search_price_level, :integer, using: 'search_price_level::integer'
    change_column :places, :details_wheelchair_accessible_entrance, :boolean, using: 'details_wheelchair_accessible_entrance::boolean'
    change_column :places, :details_serves_vegetarian_food, :boolean, using: 'details_serves_vegetarian_food::boolean'
  end
end
