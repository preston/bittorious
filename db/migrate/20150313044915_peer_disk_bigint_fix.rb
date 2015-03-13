class PeerDiskBigintFix < ActiveRecord::Migration
  def change
  	change_column	:peers, :volunteer_disk_maximum_bytes,	:integer, limit: 8
  	change_column	:peers, :volunteer_disk_used_bytes,		:integer, limit: 8
  end
end
