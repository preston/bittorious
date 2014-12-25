json.array! @users do |u|
	json.id u.id
	json.(u, :name, :email, :created_at, :updated_at, :admin, :last_sign_in_at, :approved)
	json.feeds u.feeds, :id, :name
	json.torrents u.torrents, :id, :name
end
