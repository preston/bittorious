require 'digest/sha1'
require 'bencode'
# info_hash attribute is solely for the purpose of checking if we already have the file now.
# we use private_info_hash everywhere instead.
class Torrent < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_taggable

  # Disabling Solr for now.
  # searchable do
  #   text :name, :torrent_file_file_name, :tag_list
  # end

  belongs_to :user
  belongs_to :feed
  has_many :peers, :foreign_key => 'info_hash', :primary_key => 'private_info_hash', :dependent => :destroy

  has_many :permissions, :through => :feed
  has_many :managed_by_users, :through => :permissions, :source => :user, :conditions => {:permissions => {:role => [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]}}
  # has_many :managed_by_users, :through => :permissions, :source => :user, -> {where :permissions => {:role => [Permission::SUBSCRIBER_ROLE, Permission::PUBLISHER_ROLE]}}

  has_attached_file :torrent_file,
    :processors => [:rewrite_announce],
    :styles => {
      :bt => []
    }

  validates_attachment_presence :torrent_file
  validates_presence_of :user, :name, :info_hash, :feed
  validates_uniqueness_of :info_hash, :message => 'This torrent has already been uploaded.'
  validates_uniqueness_of :slug

  after_save :rewrite_info_hash

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

  def self.announce_url
    Rails.application.routes.url_helpers.announce_url(:host => AppConfig['default_hostname'], protocol: AppConfig['default_protocol'])
  end

  private

  def rewrite_info_hash
    if torrent_file_updated_at_changed?
      b = BEncode.load_file(self.torrent_file.path(:bt))
      self.update_column(:private_info_hash, Digest::SHA1.hexdigest(b["info"].bencode))
    end
  end
end
