class User < ActiveRecord::Base

  attr_accessor :login

  has_many :identity, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :events, :dependent => :destroy

  mount_uploader :avatar, AvatarUploader

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :confirmable, # :lockable, :timeoutable
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :authentication_keys => [:login]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  validates :username, :presence => true, :uniqueness => {:case_sensitive => false }, length: { maximum: 35 }

  def self.find_for_oauth(auth, signed_in_resource = nil)

    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?

      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      if user.nil?

        user_with_username = User.find_by(username: auth.extra.raw_info.screen_name) ||
                              User.find_by(username: auth.uid)
        username0 = user_with_username.nil? ? auth.extra.raw_info.screen_name :
                                              "#{Devise.friendly_token[0,20]}"
        user = User.new(
            name: auth.extra.raw_info.name,
            username: username0 || auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20],
            avatar: auth.info.image
        )
        user.skip_confirmation!
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end

    user

  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.email || self.username
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end
end