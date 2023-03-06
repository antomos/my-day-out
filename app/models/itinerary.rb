class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :events
  has_many :places, through: :events

  validates :location, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :interests, presence: true
  validates :budget, presence: true

  attr_accessor :details_wheelchair_accessible_entrance

  INTERESTS = ["History", "Art_culture", "Dining", "Drinks", "Activity", "Shopping", "Outdoors", "Attraction"]
end
