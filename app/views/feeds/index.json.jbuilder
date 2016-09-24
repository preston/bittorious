json.array! @feeds do |f|
	json.extract! f, :id, :name, :description, :user_id, :created_at, :updated_at, :enable_public_archiving, :replication_percentage
	json.extract! f, :can_update, :can_delete
	# json.feeds u.feeds, :id, :name
	# json.torrents u.torrents, :id, :name
	# json.feeds_count f.feeds.count
	json.torrents_count f.torrents.count
end
