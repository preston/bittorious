class Collapse < ActiveRecord::Migration
    def change
        # These are extensions that must be enabled in order to support this database
        enable_extension 'uuid-ossp'

        create_table 'feeds', id: :uuid do |t|
            t.string   'name'
            t.text     'description'
            t.uuid     'user_id'
            t.datetime 'created_at'
            t.datetime 'updated_at'
            t.boolean  'enable_public_archiving', default: false
            t.integer  'replication_percentage',  default: 20
            t.index ['user_id'], name: 'index_feeds_on_user_id', using: :btree
        end

        create_table 'peers', id: :uuid do |t|
            t.string   'peer_id'
            t.string   'ip'
            t.integer  'port'
            t.integer  'uploaded'
            t.integer  'downloaded'
            t.integer  'left'
            t.string   'state'
            t.datetime 'created_at'
            t.datetime 'updated_at'
            t.float    'latitude'
            t.float    'longitude'
            t.string   'country_name'
            t.string   'city_name'
            t.uuid 'user_id'
            t.boolean  'volunteer_enabled',            default: false
            t.bigint   'volunteer_disk_maximum_bytes', default: 0
            t.bigint   'volunteer_disk_used_bytes',    default: 0
            t.integer  'volunteer_affinity_offset',    default: 0
            t.integer  'volunteer_affinity_length',    default: 0
            t.uuid  'torrent_id'
            t.index :ip
            t.index :peer_id
            t.index :user_id
        end

        create_table 'permissions', id: :uuid do |t|
            t.uuid     'user_id'
            t.uuid     'feed_id'
            t.string   'role'
            t.datetime 'created_at'
            t.datetime 'updated_at'
            t.index :feed_id
            t.index :user_id
        end

        create_table 'torrents', id: :uuid do |t|
            t.string   'name'
            t.datetime 'created_at'
            t.datetime 'updated_at'
            t.uuid     'user_id'
            t.bigint   'size'
            t.string   'info_hash',       null: false
            t.binary   'data',            null: false
            t.uuid     'feed_id'
            t.integer  'pieces'
            t.integer  'piece_length'
            t.string   'file_created_by'
            t.index :feed_id
            t.index :info_hash, unique: true
            t.index :user_id
        end

        create_table 'users', id: :uuid do |t|
            ## Database authenticatable
            t.string :email, null: false, default: ''
            t.string :encrypted_password, null: false, default: ''

            ## Recoverable
            t.string   :reset_password_token
            t.datetime :reset_password_sent_at

            ## Rememberable
            t.datetime :remember_created_at

            ## Trackable
            t.integer  :sign_in_count, default: 0, null: false
            t.datetime :current_sign_in_at
            t.datetime :last_sign_in_at
            t.string   :current_sign_in_ip
            t.string   :last_sign_in_ip

            ## Confirmable
            t.string   :confirmation_token
            t.datetime :confirmed_at
            t.datetime :confirmation_sent_at
            t.string   :unconfirmed_email # Only if using reconfirmable

            ## Lockable
            t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
            t.string   :unlock_token # Only if unlock strategy is :email or :both
            t.datetime :locked_at

            # Uncomment below if timestamps were not included in your original model.
            t.timestamps

			# Additional custom (non-Devise) stuff.
			t.boolean	:approved, defalut: false
            t.boolean	:admin,	default: false
            t.string	:name,	null: false,	default: ''
            t.string	:authentication_token

            t.index :email, unique: true
            t.index :reset_password_token, unique: true
            t.index :confirmation_token,   unique: true
            t.index :unlock_token,         unique: true
            t.index :approved
        end

        add_foreign_key	:peers,	:users
        add_foreign_key	:peers,	:torrents
        add_foreign_key	:torrents,	:users
        add_foreign_key	:torrents,	:feeds
        add_foreign_key	:permissions,	:users
        add_foreign_key	:permissions,	:feeds
        add_foreign_key	:feeds,	:users
     end
end
