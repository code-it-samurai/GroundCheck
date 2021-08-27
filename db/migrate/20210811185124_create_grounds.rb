class CreateGrounds < ActiveRecord::Migration[6.1]
  def change
    create_table :grounds do |t|
      t.string :ground_name
      t.integer :ground_pincode
      t.string :business_email
      t.integer :business_phone
      t.float :cost_per_hour
      t.time :opening_time
      t.time :closing_time

      t.timestamps
    end
  end
end
