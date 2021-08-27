class Ground < ApplicationRecord
	belongs_to :user 
	has_many :reservations, dependent: :destroy
	has_many :ground_sports_masters, dependent: :destroy
	has_many :sports_masters, through: :ground_activities
	has_many :user_sports_masters
end
