class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.references :user

      t.timestamps
    end
    add_index :feeds, :user_id
    add_index :feeds, :slug, unique: true
  end
end
