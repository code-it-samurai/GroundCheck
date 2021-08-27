class CreateSportsMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :sports_masters do |t|
      t.string :name

      t.timestamps
    end
  end
end
