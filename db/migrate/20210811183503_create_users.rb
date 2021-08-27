class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :password
      t.integer :pincode
      t.text :address
      t.string :email
      t.integer :phone
      t.boolean :ground_owner

      t.timestamps
    end
  end
end
