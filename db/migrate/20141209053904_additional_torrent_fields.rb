class AdditionalTorrentFields < ActiveRecord::Migration
  def change
	add_column	:torrents, :pieces, :integer
	add_column	:torrents, :piece_length, :integer
	add_column	:torrents, :file_created_by, :string
  end
end
