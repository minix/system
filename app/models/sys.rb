class Sys < ActiveRecord::Base
  attr_accessible :ip_addr, :service, :port, :status

	def ssh_connect
		Net::SSH.start(self.ip_addr, 'root') do |ssh|
		   puts ssh.exec!("ls -a")
		end
	end
	
end
