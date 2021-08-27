json.extract! ground, :id, :ground_name, :user_id, :ground_pincode, :business_email, :business_phone, :cost_per_hour, :opening_time, :closing_time, :created_at, :updated_at
json.url ground_url(ground, format: :json)
