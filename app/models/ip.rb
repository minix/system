class Ip < ActiveRecord::Base
	has_many :syss
<<<<<<< HEAD
	attr_accessible :ip_addr, :syss, :syss_attributes
	accepts_nested_attributes_for :syss
=======
	accepts_nested_attributes_for :syss
	attr_accessible :syss, :syss_attributes
	attr_accessible :ip_addr

	def task_attributes=(syss_attributes)
		syss_attributes.each do |attributes|
			syss.build(attributes)
		end
	end
>>>>>>> 93e5fd69651b3d0342db962cc404fe1f9ae99133
end
