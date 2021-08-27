class GroundActivities < ActiveRecord::Migration[6.1]
  def change
    change_table :ground_activities do |t|
      t.remove :user_id
      t.belongs_to :ground
    end
  end
end
