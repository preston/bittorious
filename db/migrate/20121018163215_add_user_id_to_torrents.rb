class AddUserIdToTorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :user_id, :integer #, :null => false
    add_index :torrents, :user_id
  end
end
