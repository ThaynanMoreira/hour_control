class Client < ActiveRecord::Base
  has_many :projects

  validates :name, :presence => true, :length => {:maximum => 50}, :uniqueness => true

  attr_accessible :name, :description
end
