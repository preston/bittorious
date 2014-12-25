class AddUserToPeer < ActiveRecord::Migration

  def change
  	add_column :peers, :user_id, :integer
  	add_index :peers, :user_id
  end

end
