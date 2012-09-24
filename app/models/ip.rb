class Ip < ActiveRecord::Base
	has_many :syss
	attr_accessible :ip_addr, :syss, :syss_attributes
	accepts_nested_attributes_for :syss

	private

	def ssl_conn
		begin
			client = TCPSocket.new(@ip.ip_addr, 8888)
			temp = ""
			5.times do
				temp << client.gets
			end
			public_key = OpenSSL::PKey::RSA.new(temp)
			#msg = "sh /home/scripts/nginx_status.sh"
			msg = "/etc/snmp/snmpd.conf << extend #{self.syss.oid} #{self.syss.server} /bin/sh /home/script/#{self.syss.server}_status.sh"
			sha1 = Digest::SHA1.hexdigest(msg)
			command = public_key.public_encrypt("#{sha1}*#{msg}")
			client.send(command, 0)
		rescue => e
			puts e
			retry
			client.close
		end
	end

end
