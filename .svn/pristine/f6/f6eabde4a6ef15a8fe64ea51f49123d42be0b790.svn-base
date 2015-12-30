class User < ActiveRecord::Base
	belongs_to :type
	has_many :historics
	has_many :projects
	has_many :relations, :foreign_key => "user_id", :dependent => :destroy
	has_many :projects_followeds, :through => :relations, :source => :project
	has_many :historics_followeds, :through => :projects_followeds, :source => :historics
  belongs_to :confirmation, :dependent => :destroy

	before_save :encrypt_password
	before_create :create_remember_token
	
	
  attr_accessible :name, :email, :password, :password_confirmation, :type_id
	attr_accessor :password, :password_confirmation

	validates :name, :presence => true, :length => {:maximum => 50}
	validates :type_id, :presence => true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, :presence => true, :format => {:with => VALID_EMAIL_REGEX},:uniqueness => { :case_sensitive => false}
	
	validates :password, :presence => true, :length => { :minimum => 6 }
	validates :password_confirmation, :presence => true, :length => { :minimum => 6 }
	validates_confirmation_of :password
	validates_presence_of :password, :on => :create



	def encrypt_password
	    if password.present?
	      self.password_salt = BCrypt::Engine.generate_salt
	      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
	    end
  	end

	#@user = User.where(email: email)[0]
	#@current_user = user.authenticate(password)
	def User.new_remember_token
    	SecureRandom.base64
	end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end



  private

    def create_remember_token
      t = User.new_remember_token
      self.remember_token = User.hash(t)
    end




end
