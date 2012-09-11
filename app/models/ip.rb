class Ip < ActiveRecord::Base
	has_many :syss
#	accepts_nested_attributes_for :syss
	attr_accessible :syss
	attr_accessible :ip_addr
end
