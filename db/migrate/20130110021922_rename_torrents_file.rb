class RenameTorrentsFile < ActiveRecord::Migration
  def up
    rename_column("torrents", "file_file_name", "torrent_file_file_name")
    rename_column("torrents", "file_content_type", "torrent_file_content_type")
    rename_column("torrents", "file_file_size", "torrent_file_file_size")
    rename_column("torrents", "file_updated_at", "torrent_file_updated_at")
  end

  def down
    rename_column("torrents", "torrent_file_file_name", "file_file_name")
    rename_column("torrents", "torrent_file_content_type", "file_content_type")
    rename_column("torrents", "torrent_file_file_size", "file_file_size")
    rename_column("torrents", "torrent_file_updated_at", "file_updated_at")
  end
end
