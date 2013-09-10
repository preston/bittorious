class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, :default => 'user'
    add_index :users, :role
  end
end
