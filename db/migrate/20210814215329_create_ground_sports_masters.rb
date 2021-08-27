class CreateGroundSportsMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :ground_sports_masters do |t|
      t.integer :ground_id
      t.integer :sports_master_id

      t.timestamps
    end
  end
end
