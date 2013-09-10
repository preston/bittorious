class AddAttachmentFileToTorrents < ActiveRecord::Migration
  def self.up
    change_table :torrents do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :torrents, :file
  end
end
