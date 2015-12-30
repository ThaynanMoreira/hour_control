class Project < ActiveRecord::Base

	belongs_to :user
	belongs_to :client
	has_many :timetables
  has_many :historics, :dependent => :destroy
	has_many :relations, :foreign_key => "project_id", :dependent => :destroy
  has_many :users_followeds, :through => :relations, :source => :user

	validates :name, :presence => true, :length => {:maximum => 50}, :uniqueness => true
  validates :client_id, :presence => true
	attr_accessible :name, :description, :client_id




  private
  def user_name_conditions
    ["name LIKE ?", "%#{Search.get_search_word}%"] unless Search.get_search_word.blank?
  end

end
