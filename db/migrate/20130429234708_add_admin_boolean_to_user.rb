class AddAdminBooleanToUser < ActiveRecord::Migration

  def change
  	# Add the admin bit.
  	add_column	:users, :admin, :boolean, default: false

  	# Set the bit for existing admins.
  	User.where(role: User::ADMIN_ROLE).update_all(admin: true)

  	# Everyone reasonable rolse in each feed by default.
  	User.all.each do |u|
  		old = User.role
  		r = Permission::SUBSCRIBER_ROLE
  		case old
  		when 'admin'
  			r = Permission::PUBLISHER_ROLE
  		when 'publisher'
  			r = Permission::PUBLISHER_ROLE
  		end
  		Feed.all.each do |f|
  			Permission.create(feed: f, user: u, role: r)
  		end
  	end

  	# Remove the role field.
  	remove_column :users, :role


  end

end
