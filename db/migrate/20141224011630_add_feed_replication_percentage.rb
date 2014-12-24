class AddFeedReplicationPercentage < ActiveRecord::Migration

  def change
  	add_column	:feeds, :replication_percentage, :integer, default: 20
  end

end
