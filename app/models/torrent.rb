require 'digest/sha1'
require 'bencode'

class Torrent < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged


  belongs_to :user
  belongs_to :feed, touch: true
  has_many :peers, :foreign_key => 'info_hash', :primary_key => 'info_hash', :dependent => :destroy

  has_many :permissions, :through => :feed
  # has_many :managed_by_users, :through => :permissions, :source => :user, :conditions => {:permissions => {:role => [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]}}
  # has_many :managed_by_users, :through => :permissions, :source => :user, -> {where :permissions => {:role => [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]}}


  validates_presence_of :user, :name, :info_hash, :feed
  validates_uniqueness_of :info_hash, :message => 'This torrent has already been uploaded.'
  validates_uniqueness_of :slug

  # Freely available geocoding data file.
  GEOIP_DATA = File.join(Rails.root, 'public', 'data', 'GeoLiteCity.dat')
  GEOIP = GeoIP.new(GEOIP_DATA)

  # Force slug regeneration every time the record is saved.
  def should_generate_new_friendly_id?() true end


  default_scope {order('created_at')}
  scope :managed_by_user, lambda{|user| joins(:permissions).where(permissions: {user_id: user.id, role: [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]})}
  

  def register_peer(peer_params, user = nil)
    peer = Peer.find_or_create_by!(info_hash: peer_params[:info_hash], peer_id: peer_params[:peer_id])
    peer.update_attributes(
      downloaded:   peer_params['downloaded'],
      uploaded:     peer_params[:uploaded],
      state:        peer_params[:event],
      port:         peer_params[:port],
      left:         peer_params[:left],
      ip:           peer_params[:remote_ip]
      )
    peer.touch
    if(peer.latitude.nil? || peer.longitude.nil?)
      data = GEOIP.city(peer.ip)
      peer.latitude = data.latitude
      peer.longitude = data.longitude
      peer.country_name = data.country_name
      peer.city_name = data.city_name
    end
    peer.user = user
    peer.save!
    peer
  end

  def active_peers
    self.peers.active
  end

  def seed_count
    "#{self.peers.active.seeds.count}"
  end

  def peer_count
    "#{self.peers.active.peers.count}"
  end

  def data_for_user(user, announce_url)
    b = BEncode.load(self.data)
    params = "?authentication_token=#{user.authentication_token}"
    url = announce_url + params
    b['announce'] = url
    b["announce-list"] = [[url]]
    b.to_bencoding
  end

  def reprocess_meta
    b = BEncode.load(self.data)

    # The announce fields will be customized per user, so we can trash the originals.
    b['announce'] = ''
    b["announce-list"] = [[]]

    b["info"]["private"] = (self.feed.enable_public_archiving ? 0 : 1)
    b["info"]["name"] = self.name
    # Shameless plug. :)
    b["comment"] = "Powered by BitTorious!"

    self.file_created_by = b["created by"]
    self.size = b['info']['length']
    self.pieces = b['info']['pieces'].length / 20
    self.piece_length = b['info']['piece length']
    self.data = b.to_bencoding

    b = BEncode.load(self.data)
    self.info_hash = Digest::SHA1.hexdigest(b["info"].bencode)
    true
  end
end
