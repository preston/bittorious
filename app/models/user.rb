class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  ADMIN_ROLE = 'admin'

  has_many :torrents
  has_many :feeds, :dependent => :destroy

  has_many :permissions, :dependent => :destroy

  validates_uniqueness_of :email

  after_create :send_admin_mail
  # after_update :send_confirmation

  before_destroy :verify_no_torrents

  scope :pending, -> {where(:approved => false)}
  scope :approved, -> {where(:approved => true)}


  def to_s
    name || email
  end

  def as_json(options={})
    super(:methods =>[:auth_token])
  end

  def to_xml(options={})
    super(:methods =>[:auth_token])
  end

  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  
  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(self).deliver 
  end

  def deny!
    AdminMailer.deny_application(self).deliver
    self.destroy
  end

  def approve!
    self.approved = true
    self.save
  end

  # def send_confirmation
  #   if self.approved_changed?
  #     ::Devise.mailer.confirmation_instructions(self).deliver
  #   end
  # end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def transfer_ownership(user)
    if !user or user.id.nil?
      errors.add(:base, "User must be specified to transfer ownership")
      return false
    else
      self.torrents.update_all(:user_id => user.id) && self.feeds.update_all(:user_id => user.id)
    end
  end


  private
  def verify_no_torrents
    if self.torrents.count != 0
      return false
    end
  end

  # You likely have this before callback set up for the token.
  before_save :ensure_authentication_token
 
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
