class Reservation < ApplicationRecord
	belongs_to :user
	belongs_to :ground
	belongs_to :sports_master
end
