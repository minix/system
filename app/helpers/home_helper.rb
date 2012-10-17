module HomeHelper
	def get_oid
		custom_oid = ('1'..'9').to_a.shuffle[0..3].join
		custom_a_oid = ('1'..'9').to_a.shuffle[0..3].join
		#avoid first custom same
		return ".1.3.6.1.4.1.2021.#{custom_oid}.#{custom_a_oid}"
	end
end
