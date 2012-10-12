class Sys < ActiveRecord::Base
	belongs_to :ip
	attr_accessible :server, :port, :oid
	
	before_save :oid

	private

end
