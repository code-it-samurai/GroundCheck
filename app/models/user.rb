class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	has_many :grounds, dependent: :destroy
	has_many :reservations, dependent: :destroy
	has_many :user_sports_masters, dependent: :destroy
end
