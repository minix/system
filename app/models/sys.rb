class Sys < ActiveRecord::Base
	belongs_to :ip
	attr_accessible :server, :port, :oid
	
	before_save :oid

	def oid
		custom_oid = ('1'..'9').to_a.shuffle[0..3].join
		self.oid = ".1.3.6.1.4.2021.#{custom_oid}"
	end

	private

end
