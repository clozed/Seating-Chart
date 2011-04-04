class Chart < ActiveRecord::Base
	validates :user_id, :uniqueness => { :scope => [:user_id, :seat] }

	has_many :user, :order => 'seat ASC'

	attr_accessor :username
end
