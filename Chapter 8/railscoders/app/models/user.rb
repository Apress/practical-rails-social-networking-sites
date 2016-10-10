require 'digest/sha2'
class User < ActiveRecord::Base
  attr_protected :hashed_password, :enabled
  attr_accessor :password

  validates_presence_of :username 
  validates_presence_of :email 
  validates_presence_of :password, :if => :password_required?
  validates_presence_of :password_confirmation, :if => :password_required?

  validates_confirmation_of :password, :if => :password_required?
  
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  
  validates_length_of :username, :within => 3..64
  validates_length_of :email, :within => 5..128  
  validates_length_of :password, :within => 4..20, :if => :password_required?
  validates_length_of :profile, :maximum => 1000

  has_and_belongs_to_many :roles
  has_many :articles
  has_many :entries
  has_many :comments
  has_many :photos

  def before_save
    self.hashed_password = User.encrypt(password) if !password.blank?
  end

  def password_required?
    hashed_password.blank? || !password.blank?
  end

  def self.encrypt(string)
    return Digest::SHA256.hexdigest(string)
  end
  
  def self.authenticate(username, password)
    find_by_username_and_hashed_password_and_enabled(username, 
        User.encrypt(password), true)
  end
  
  def has_role?(rolename)
    self.roles.find_by_name(rolename) ? true : false
  end
  
  def email_with_username
    "#{username} <#{email}>"
  end  
end
