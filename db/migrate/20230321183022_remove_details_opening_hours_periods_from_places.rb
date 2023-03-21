class RemoveDetailsOpeningHoursPeriodsFromPlaces < ActiveRecord::Migration[7.0]
  def change
    remove_column :places, :details_opening_hours_periods
  end
end
