class AddPrivateInfoHashTotorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :private_info_hash, :string
    add_index :torrents, :private_info_hash
  end
end
