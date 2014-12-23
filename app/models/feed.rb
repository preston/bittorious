class Feed < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates_presence_of :name
  validates_presence_of :user_id
  validates_uniqueness_of :name
  validates_uniqueness_of :slug

  belongs_to :user
  has_many :torrents, dependent: :destroy
  has_many :permissions, dependent: :destroy

  # before_destroy :verify_no_torrents

  attr_accessor :can_manage

  def attributes
    super.merge({can_manage: can_manage})
  end

  private

  # def verify_no_torrents
  #   if self.torrents.count != 0
  #     return false
  #   end
  # end

end
