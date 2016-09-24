require 'digest/sha1'
require 'bencode'

class Torrent < ApplicationRecord

    belongs_to :user
    belongs_to :feed, touch: true
    has_many :peers, dependent: :destroy

    has_many :permissions, through: :feed

    validates_presence_of :user, :name, :info_hash, :feed
    validates_uniqueness_of :info_hash, message: 'This torrent has already been uploaded.'

    # Freely available geocoding data file.
    GEOIP_DATA = File.join(Rails.root, 'public', 'data', 'GeoLiteCity.dat')
    GEOIP = GeoIP.new(GEOIP_DATA)

    attr_accessor :file # Temporary file upload.

    # default_scope {order('created_at')}
    scope :managed_by_user, ->(user) { joins(:permissions).where(permissions: { user_id: user.id, role: [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE] }) }

    def register_peer(peer_params, user = nil)
        torrent = Torrent.where(info_hash: peer_params[:info_hash]).first
        peer = Peer.find_or_create_by!(torrent_id: torrent, peer_id: peer_params[:peer_id])
        peer.torrent = torrent
        peer.update_attributes(
            downloaded:   peer_params['downloaded'],
            uploaded:     peer_params[:uploaded],
            state:        peer_params[:event],
            port:         peer_params[:port],
            left:         peer_params[:left],
            ip:           peer_params[:remote_ip]
        )
        peer.touch
        if peer.latitude.nil? || peer.longitude.nil?
            data = GEOIP.city(peer.ip)
            peer.latitude = data.latitude
            peer.longitude = data.longitude
            peer.country_name = data.country_name
            peer.city_name = data.city_name
        end
        peer.user = user

        # puts "VOL: #{peer_params[:volunteer]}"
        if !peer_params[:volunteer].nil? && peer_params[:volunteer]['enabled'] == '1'
            peer.volunteer_enabled = true
            peer.volunteer_disk_maximum_bytes = peer_params[:volunteer]['disk_maximum_bytes'].to_i
            peer.volunteer_disk_used_bytes = peer_params[:volunteer]['disk_used_bytes'].to_i
        else
            peer.volunteer_enabled = false
            peer.volunteer_disk_maximum_bytes = 0
            peer.volunteer_disk_used_bytes = 0
        end
        peer.save!
        peer
    end

    def active_peers
        peers.active
    end

    def seed_count
        peers.active.seeds.count.to_s
    end

    def peer_count
        peers.active.peers.count.to_s
    end

    def data_for_user(user, announce_url)
        b = BEncode.load(data)
        params = ''
        if user && user.authentication_token
            params = "?authentication_token=#{user.authentication_token}"
        end
        url = announce_url + params
        b['announce'] = url
        b['announce-list'] = [[url]]
        b.to_bencoding
    end

    def reprocess_meta
        b = BEncode.load(data)

        # The announce fields will be customized per user, so we can trash the originals.
        b['announce'] = ''
        b['announce-list'] = [[]]

        b['info']['private'] = (feed.enable_public_archiving ? 0 : 1)
        b['info']['name'] = name
        # Shameless plug. :)
        b['comment'] = 'Powered by BitTorious!'
		b['creation date'] = self.created_at.to_i

        self.file_created_by = b['created by']
        self.size = b['info']['length']
        self.pieces = b['info']['pieces'].length / 20
        self.piece_length = b['info']['piece length']
        self.data = b.to_bencoding

        b = BEncode.load(data)
        self.info_hash = Digest::SHA1.hexdigest(b['info'].bencode)
        self
    end
end
