class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :places, through: :events

  attr_accessor :details_wheelchair_accessible_entrance

  INTERESTS = ["History", "Art_culture", "Dining", "Drinks", "Activity", "Shopping", "Outdoors", "Attraction"]
end
