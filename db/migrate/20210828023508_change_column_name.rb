class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :reservations, :active, :status
  end
end
