class AddFeedToTorrent < ActiveRecord::Migration
  def change
    add_column :torrents, :feed_id, :integer
    add_index :torrents, :feed_id
  end
end
