class GroundSportsMasters < ActiveRecord::Migration[6.1]
  def change
    change_table :ground_sports_masters do |t|
      t.remove :ground_id
      t.remove :sports_master_id
      t.belongs_to :ground
      t.belongs_to :sports_master
    end
  end
end
