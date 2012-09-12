class Sys < ActiveRecord::Base
	belongs_to :ip
	attr_accessible :ip_id, :server, :port
end
