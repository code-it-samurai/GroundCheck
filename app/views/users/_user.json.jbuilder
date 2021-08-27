json.extract! user, :id, :username, :name, :password, :pincode, :address, :email, :phone, :ground_owner, :created_at, :updated_at
json.url user_url(user, format: :json)
