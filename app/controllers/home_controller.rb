require 'ipaddr'
require 'socket'
require 'digest/sha1'
require "openssl"

class HomeController < ApplicationController
  def index
		@status = Sys.find(:all)
  end

	def status

	end

	def add
		@add_dev = Sys.new(params[:add_dev])
		if request.post?
			if @add_dev.save
				redirect_to controller: "home", action: "index"
			end		
		end
	end

	def start
		begin
			client = TCPSocket.new('192.168.186.128', 8888)
			#client = TCPSocket.new('0.0.0.0', 8888)
			temp = ""
			5.times do
				temp << client.gets
			end

			public_key = OpenSSL::PKey::RSA.new(temp)
			msg = 'sh /home/scripts/start_nginx.sh'
			sha1 = Digest::SHA1.hexdigest(msg)
			command = public_key.public_encrypt("#{sha1}*#{msg}")
			client.send(command, 0)
			rescue => e
				puts e
				retry
			client.close
		end
	end

	def stop
		begin
		  client = TCPSocket.new('192.168.186.128', 8888)
		  temp = ""
		  5.times do
		    temp << client.gets
		  end
		
		  public_key = OpenSSL::PKey::RSA.new(temp)
			msg = 'sh /home/scripts/stop_nginx.sh'
		  sha1 = Digest::SHA1.hexdigest(msg)

		  command = public_key.public_encrypt("#{sha1}*#{msg}")
		  client.send(command,0)
		rescue => e
		  puts e
		  retry
		end
		
		client.close

	end

	private
	def real_ip(ip)
		new_ip = IPAddr.new(ip).to_i
		return new_ip
	end
end
