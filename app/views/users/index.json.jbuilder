json.array! @users do |u|
	json.extract! u, :id, :name, :email, :created_at, :updated_at, :admin, :confirmed_at, :last_sign_in_at, :approved
	# json.feeds u.feeds, :id, :name
	# json.torrents u.torrents, :id, :name
	json.feeds_count u.feeds.count
	json.torrents_count u.torrents.count
end
