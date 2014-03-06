class BaseModel < ActiveRecord::Migration

	def change
		create_table "feeds", force: true do |t|
			t.string   "name"
			t.string   "slug"
			t.text     "description"
			t.integer  "user_id"
			t.datetime "created_at"
			t.datetime "updated_at"
			t.boolean  "enable_public_archiving", default: false
		end
	
		add_index "feeds", "slug", unique: true
		add_index "feeds", "user_id"
	
		create_table "peers", force: true do |t|
			t.string   "peer_id"
			t.string   "info_hash"
			t.string   "ip"
			t.integer  "port"
			t.integer  "uploaded"
			t.integer  "downloaded"
			t.integer  "left"
			t.string   "state"
			t.datetime "created_at"
			t.datetime "updated_at"
			t.float    "latitude"
			t.float    "longitude"
		end
	
		add_index "peers", ["info_hash", "state"]
		add_index "peers", "ip"
		add_index "peers", "peer_id"
	
		create_table "permissions", force: true do |t|
			t.integer  "user_id"
			t.integer  "feed_id"
			t.string   "role"
			t.datetime "created_at"
			t.datetime "updated_at"
		end
	
		add_index "permissions", "feed_id"
		add_index "permissions", "user_id"
	

		create_table "torrents", force: true do |t|
			t.string   "name"
			t.string   "slug"
			t.datetime "created_at"
			t.datetime "updated_at"
			t.integer  "user_id"
			t.string   "torrent_file_file_name"
			t.string   "torrent_file_content_type"
			t.integer  "torrent_file_file_size"
			t.datetime "torrent_file_updated_at"
			t.integer  "size",                      limit: 8
			t.string   "info_hash"
			t.integer  "feed_id"
			t.string   "private_info_hash"
		end
	
		add_index "torrents", "feed_id"
		add_index "torrents", "info_hash", unique: true
		add_index "torrents", "private_info_hash"
		add_index "torrents", "slug", unique: true
		add_index "torrents", "user_id"
	end

end
