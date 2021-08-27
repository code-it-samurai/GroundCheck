class Reservations < ActiveRecord::Migration[6.1]
  def change
    change_table :reservations do |t|
      t.remove :cost
      t.integer :cost
    end 
  end
end
