class AddDetailsOpeningHoursPeriodsToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :details_opening_hours_periods, :jsonb, default: {}
  end
end
