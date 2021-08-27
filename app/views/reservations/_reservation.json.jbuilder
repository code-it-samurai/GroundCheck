json.extract! reservation, :id, :user, :ground, :selected_activity, :starting_time, :finishing_time, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
