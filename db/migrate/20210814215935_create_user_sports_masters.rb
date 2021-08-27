class CreateUserSportsMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :user_sports_masters do |t|
      t.integer :user_id
      t.integer :sports_master_id

      t.timestamps
    end
  end
end
