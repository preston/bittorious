class Feed < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :user_id
  validates_uniqueness_of :name

  belongs_to :user
  has_many :torrents, dependent: :destroy
  has_many :permissions, dependent: :destroy

  validates_numericality_of :replication_percentage,
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 100

  attr_accessor :can_update, :can_delete

  after_save :regenerate_torrent_files

  def regenerate_torrent_files
    self.torrents.each do |t|
      t.reprocess_meta
      t.save!
    end
  end

  def attributes
    super.merge({
      can_update: can_update,
      can_delete: can_delete
    })
  end


end
