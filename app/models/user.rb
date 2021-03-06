class User < ApplicationRecord

  validates :email, :format => { :with => /\w+[@]\w+[.]\w{1}\w+/}, uniqueness: true, :presence => true
  validates :password, presence: true

  has_secure_password

  has_many :posts
  has_many :comments

  has_many :authentications, dependent: :destroy

  def self.create_with_auth_and_hash(authentication, auth_hash)
   user = self.create!(
     first_name: auth_hash["info"]["first_name"],
     last_name: auth_hash["info"]["last_name"],
     email: auth_hash["info"]["email"],
     password: SecureRandom.hex(10),
   )
   user.authentications << authentication
   return user
 end

 # grab google to access google for user data
 def google_token
   x = self.authentications.find_by(provider: 'google_oauth2')
   return x.token unless x.nil?
 end

 def full_name
   "#{self.first_name} #{self.last_name}"
 end

end
