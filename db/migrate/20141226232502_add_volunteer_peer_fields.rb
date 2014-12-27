class AddVolunteerPeerFields < ActiveRecord::Migration

	def change
		add_column	:peers, :volunteer_enabled, :boolean, default: false
		add_column	:peers, :volunteer_disk_maximum_bytes, :integer, default: 0
		add_column	:peers, :volunteer_disk_used_bytes, :integer, default: 0
		add_column	:peers, :volunteer_affinity_offset, :integer, default: 0
	end

end
