class UserActivity < ApplicationRecord
	belongs_to :user
	belongs_to :sports_master
end
