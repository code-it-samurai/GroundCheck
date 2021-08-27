class SportsMasters < ActiveRecord::Migration[6.1]
  def change
    change_table :sports_masters do |t|
      t.boolean :indoor
      t.boolean :outdoor
    end    
  end
end
