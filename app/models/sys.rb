class Sys < ActiveRecord::Base
	belongs_to :ip
	attr_accessible :server, :port, :oid
end
