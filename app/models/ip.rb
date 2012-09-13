class Ip < ActiveRecord::Base
	has_many :syss
	attr_accessible :ip_addr, :syss, :syss_attributes
	accepts_nested_attributes_for :syss

end
