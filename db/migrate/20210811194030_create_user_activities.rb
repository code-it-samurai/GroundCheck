class CreateUserActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :user_activities do |t|
      t.belongs_to :user
      t.belongs_to :sports_master
      t.timestamps
    end
  end
end
