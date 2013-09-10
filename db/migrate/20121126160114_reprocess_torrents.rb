class ReprocessTorrents < ActiveRecord::Migration
  def up
    Torrent.all.each do |t|
      t.file.reprocess!
      t.save
    end
  end

  def down
    Torrent.all.each do |t|
      t.file.reprocess!
      t.save
    end
  end
end
