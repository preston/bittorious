class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user
      t.references :feed
      t.string :role

      t.timestamps
    end
    add_index :permissions, :user_id
    add_index :permissions, :feed_id
  end
end
