class Grounds < ActiveRecord::Migration[6.1]
  def change
    change_table :grounds do |t|
      t.text :location
    end
  end
end
