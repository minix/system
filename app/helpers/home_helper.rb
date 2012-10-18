module HomeHelper
	def get_oid
		custom_oid = ('1'..'9').to_a.shuffle[0..3].join
		custom_a_oid = ('1'..'9').to_a.shuffle[0..3].join
		#avoid first custom same
		return ".1.3.6.1.4.1.2021.#{custom_oid}.#{custom_a_oid}"
		#case server
		#when 'nginx'
		#	return ".1.3.6.1.4.1.2021.#{custom_oid}.#{custom_a_oid}.3.1.1.12.110.103.105.110.120.95.115.116.97.116.117.115"
		#when 'mysql'
		#	return ".1.3.6.1.4.1.2021.#{custom_oid}.#{custom_a_oid}.3.1.1.13.109.121.115.113.108.100.95.115.116.97.116.117.115"
		#when 'mongo' 
		#	return ".1.3.6.1.4.1.2021.#{custom_oid}.#{custom_a_oid}.3.1.1.12.109.111.110.103.111.95.115.116.97.116.117.115"
		#else
		#	return ".1.3.6.1.4.1.2021.#{custom_oid}.#{custom_a_oid}"
		#end
	end
end
