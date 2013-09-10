class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved, :boolean
    add_index  :users, :approved
    execute('UPDATE users SET approved=1')
  end
end
