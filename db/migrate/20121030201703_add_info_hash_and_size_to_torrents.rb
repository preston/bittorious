class AddInfoHashAndSizeToTorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :size, :integer, :limit => 8
    add_column :torrents, :info_hash, :string #, :null => false
    add_index :torrents, :info_hash, :uniq => true
  end
end
