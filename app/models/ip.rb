class Ip < ActiveRecord::Base
	has_many :syss
	accepts_nested_attributes_for :syss
	attr_accessible :syss, :syss_attributes
	attr_accessible :ip_addr

	def task_attributes=(syss_attributes)
		syss_attributes.each do |attributes|
			syss.build(attributes)
		end
	end
end
