class SportsMaster < ApplicationRecord
	has_many :reservations, dependent: :destroy
	has_many :user_sports_masters
	has_many :users, through: :user_sports_masters
	has_many :ground_sports_masters
	has_many :grounds, through: :ground_sports_masters
end
