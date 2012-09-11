require 'ipaddr'
require 'socket'
require 'digest/sha1'
require "openssl"

class HomeController < ApplicationController
  def index
		@status = Sys.find(:all)
		if request.post?
			ssl_conn
		end
  end

	def status

	end

	def new
		@add_dev = Ip.new
		@add_dev.syss = Sys.new
	end

	def edit
		@mach = Sys.find(params[:id])
	end

	def updateing
		@mac = Ip.find(params[:id])
		@mac.update_attributes(params[:mach])
		redirect_to(controller: "home", action: "index")
	end

	def add
		@add_dev = Ip.new(params[:add_dev])
		@add_dev.syss = Sys.new(params[:syss])
		#if request.post?
		if 	@add_dev.save 
			@add_dev.syss.save
			redirect_to controller: "home", action: "index"
		end
	end

	def start
		@system = Sys.find(params[:id])
		ssl_conn
	end

	def stop
		@system = Sys.find(params[:id])
			begin
			  client = TCPSocket.new(@system.ip_addr, 8888)
			  temp = ""
			  5.times do
			    temp << client.gets
			  end
			
			  public_key = OpenSSL::PKey::RSA.new(temp)
				msg = "sh /home/scripts/stop_#{@system.service}.sh"
			  sha1 = Digest::SHA1.hexdigest(msg)

			  command = public_key.public_encrypt("#{sha1}*#{msg}")
			  client.send(command,0)
			rescue => e
			  puts e
			  retry
				client.close
			end
	end

	private
	def real_ip(ip)
		new_ip = IPAddr.new(ip).to_i
		return new_ip
	end

	def ssl_conn
		begin
			client = TCPSocket.new(@system.ip_addr, 8888)
			temp = ""
			5.times do
				temp << client.gets
			end

			public_key = OpenSSL::PKey::RSA.new(temp)
			msg = "sh /home/scripts/start_#{@system.service}.sh"
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

