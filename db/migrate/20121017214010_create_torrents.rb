class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :torrents, :slug, unique: true
  end
end
