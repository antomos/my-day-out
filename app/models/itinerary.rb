class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :events
  has_many :places, through: :events

  validates :start_address, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :interests, presence: true
  geocoded_by :start_address
  after_validation :geocode, if: :will_save_change_to_start_address?

  attr_accessor :details_wheelchair_accessible_entrance

  INTERESTS = ["History", "Art & Culture", "Dining", "Drinks", "Activity", "Shopping", "Outdoors", "Attraction"]
end
