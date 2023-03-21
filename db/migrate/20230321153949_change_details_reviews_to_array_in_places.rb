class ChangeDetailsReviewsToArrayInPlaces < ActiveRecord::Migration[7.0]
  def up
    change_column :places, :details_reviews, :text, array: true, default: [], using: "(string_to_array(details_reviews, ','))"
  end

  def down
    change_column :places, :details_reviews, :string
  end
end
