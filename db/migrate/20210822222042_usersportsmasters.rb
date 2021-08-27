class Usersportsmasters < ActiveRecord::Migration[6.1]
  def change
    change_column_null :user_sports_masters, :sports_master_id, true
  end
end
