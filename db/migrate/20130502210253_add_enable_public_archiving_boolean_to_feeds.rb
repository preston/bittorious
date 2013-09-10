class AddEnablePublicArchivingBooleanToFeeds < ActiveRecord::Migration

  def change
  	add_column	:feeds, :enable_public_archiving, :boolean, default: false
  end
 
end
