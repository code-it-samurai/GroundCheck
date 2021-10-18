class Reservations < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      change_table :reservations do |t|
        dir.up   { t.change :active, :string }
        dir.down { t.change :active, :boolean }
      end
    end            
  end
end
