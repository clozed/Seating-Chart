require 'digest'
class User < ActiveRecord::Base
  #attr_accessor :password

  validates :username, :uniqueness => true, 
			  :length => { :within => 4..30 }

  validates :password, :confirmation => true, 
			  :length => { :within => 4..20 },
		 	  :presence => true#,
			  #:if => :password_required?
  has_one :chart

  before_save :encrypt_new_password

  def self.authenticate (username, password)
   user = find_by_username(username)
    return user if user && user.authenticated?(password)
  end

  def authenticated?(password)
    #self.hash_password == encrypt(password)
    self.password == encrypt(password)
  end

  protected
    def encrypt_new_password
      #return if password.blank?
      #self.hash_password = encrypt(password)
      self.password = encrypt(self.password)
    end

    def password_required?
      #hashed_password.blank? || password.present?
      password.blank? || password.present?
    end

   def encrypt(string)
      Digest::SHA1.hexdigest(string)
    end
end
