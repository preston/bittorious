json.array! @torrents do |t|
	json.extract! t, :id, :name, :created_at, :updated_at, :user_id, :size, :info_hash, :feed_id, :pieces, :piece_length, :file_created_by
	json.seed_count t.seed_count
	json.peer_count t.peer_count
	json.user do
		json.extract! t.user, :id, :name
	end
end
