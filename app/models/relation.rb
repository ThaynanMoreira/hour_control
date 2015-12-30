class Relation < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

	attr_accessible :user_id, :project_id
	
	validates :user_id, :presence => true
  validates :project_id, :presence => true

  	
end
