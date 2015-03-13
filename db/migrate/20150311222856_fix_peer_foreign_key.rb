class FixPeerForeignKey < ActiveRecord::Migration
  def change
  	# Unfortunatey we'll need to let all peer register. Oh well.
  	Peer.destroy_all
  	add_column	:peers, :torrent_id, :integer
  	remove_column :peers, :info_hash, :integer
  end
end
