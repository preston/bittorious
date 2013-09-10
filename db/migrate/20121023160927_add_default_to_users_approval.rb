class AddDefaultToUsersApproval < ActiveRecord::Migration
  def change
    change_column :users, :approved, :boolean, :default => 0
    execute('UPDATE users SET approved=0 WHERE approved IS NULL')
  end
end
