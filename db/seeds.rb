admin = nil
begin
	admin = User.create! do |u|
		u.name = 'Default Administrator'
	 	u.email = 'admin@example.com'
	 	u.password = 'password'
	 	u.password_confirmation = 'password'
		u.admin = true
	end
	admin.confirm!
	admin.approve!
rescue
	# Already exists!
	admin = User.find_by_email('admin@example.com')
ensure
	# admin.update_attribute(:approved, true)
	# admin.update_attribute(:super_user, true)
end

subscriber = User.find_by_email('subscriber@example.com') || User.create({
	name: 'Test Subscriber',
	email: 'subscriber@example.com',
	password: 'password',
	password_confirmation: 'password',
	approved: true
	})
subscriber.confirm!

publisher = User.find_by_email('publisher@example.com') || User.create({
	name: 'Test Publisher',
	email: 'publisher@example.com',
	password: 'password',
	password_confirmation: 'password',
	approved: true
	})
publisher.confirm!

(1..8).each do |i|
	tmp = User.find_by_email("pending#{i}@example.com") || User.create({
	name: "Pending #{i}",
	email: "pending#{i}@example.com",
	password: 'password',
	password_confirmation: 'password',
	approved: false
	})
	tmp.confirm!
end

begin
  # torrent = admin.torrents.find_or_create_by_name('Torrent Foo')
  # torrent.create_tracker
end

feed = Feed.create!(name: 'Sample Feed', description: 'A feed of random data torrents for demonstration, evaluation and testing purposes.', user: admin)
Permission.create!(user: subscriber, feed: feed, role: Permission::SUBSCRIBER_ROLE)
Permission.create!(user: publisher, feed: feed, role: Permission::PUBLISHER_ROLE)

