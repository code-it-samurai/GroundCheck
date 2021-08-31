class Createuseractivities < ActiveRecord::Migration[6.1]
  def change
    drop_table :user_activities
  end
end
