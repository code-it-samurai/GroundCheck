class Changecolumndefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :ground_owner, false
  end
end
