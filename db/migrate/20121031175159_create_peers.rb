class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.string :peer_id
      t.string :info_hash
      t.string :ip
      t.integer :port
      t.integer :uploaded
      t.integer :downloaded
      t.integer :left
      t.string :state

      t.timestamps
    end
    add_index :peers, [:info_hash, :state]
    add_index :peers, :ip
    add_index :peers, :peer_id
  end
end
