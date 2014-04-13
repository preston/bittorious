require 'digest/sha1'
require 'bencode'

class Torrent < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged


  belongs_to :user
  belongs_to :feed
  has_many :peers, :foreign_key => 'info_hash', :primary_key => 'private_info_hash', :dependent => :destroy

  has_many :permissions, :through => :feed
  # has_many :managed_by_users, :through => :permissions, :source => :user, :conditions => {:permissions => {:role => [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]}}
  # has_many :managed_by_users, :through => :permissions, :source => :user, -> {where :permissions => {:role => [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]}}


  validates_presence_of :user, :name, :info_hash, :feed
  validates_uniqueness_of :info_hash, :message => 'This torrent has already been uploaded.'
  validates_uniqueness_of :slug

  # before_save :reprocess_meta

  default_scope {order('created_at')}
  scope :managed_by_user, lambda{|user| joins(:permissions).where(permissions: {user_id: user.id, role: [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]})}
  

  def register_peer(peer_params)
    peer = Peer.find_or_create_by_info_hash_and_peer_id(peer_params[:info_hash], peer_params[:peer_id])
    peer.update_attributes(
      downloaded:   peer_params['downloaded'],
      uploaded:     peer_params[:uploaded],
      state:        peer_params[:event],
      port:         peer_params[:port],
      left:         peer_params[:left],
      ip:           peer_params[:remote_ip]
      )
    peer.touch
    peer
  end

  def seed_count
    self.peers.active.seeds.count
  end

  def peer_count
    self.peers.active.peers.count
  end

  def as_json(options={})
    {
      name: self.name,
      torrent_url: torrent_url,
      publisher: self.user.name
    }
  end

  def torrent_url
    self.torrent_file.url(:bt)
  end

  def to_xml(options = {})
    super options.merge({:methods => [:torrent_url]})
  end

  # private

  def reprocess_meta(announce_url)
    b = BEncode.load(self.data)
    b['announce'] = announce_url
    b["announce-list"] = [[announce_url]]
    b["comment"] = "Powered by BitTorious!"
    b["info"]["private"] = 1
    self.data = b.to_bencoding
    self.size = b['info']['length']

    b = BEncode.load(self.data)
    self.info_hash = Digest::SHA1.hexdigest(b["info"].bencode)
    puts "HASHY!!! #{info_hash}"
    true
  end
end
