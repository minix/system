require 'socket'
require 'digest/sha1'
require "openssl"

class HomeController < ApplicationController
	def index
		@add_dev = Ip.find :all
	end

	def status

	end

	def new
		@add_dev = Ip.new(params[:add_dev])
		3.times { @add_dev.syss.build }

		respond_to do |format|
			format.html
			format.js
		end
	end

	def show

	end

	def destroy
		destroy_id = params[:id]
		Sys.where("ip_id = #{destroy_id}").each do |destroy_server|
			destroy_server.destroy
		end
		Ip.destroy(destroy_id)
		flash[:notice] = "Success destroy derive!"
		redirect_to controller: "home", action: "index"
	end

	def create
		@add_dev = Ip.new(params[:add_dev])
		respond_to do |format|
	 		if @add_dev.save
			@ip = Ip.find_by_id(@add_dev)
			Sys.where("ip_id = #{@ip.id}").each do |oid_add|
				ssl_conn("echo \"extend #{oid_add.oid} /bin/sh /home/script/#{oid_add.server}_status.sh\" >> /etc/snmp/snmpd.conf")
			end
				format.html { redirect_to controller: "home", action: "index" }
				format.js { render :layout => false }
			else
				format.html { render :new }
				format.js { render :layout => false, :status => 406  }
			end
		end
	end

	def edit
		@mach = Sys.find(params[:id])
	end

	def update
		@mac = Sys.find(params[:id])
		@mac.update_attributes(params[:mach])
		redirect_to(controller: "home", action: "index")
	end

	def start
		@system = Sys.find_by_id(params[:id])
		@ip = Ip.find_by_id(@system.ip_id)
		ssl_conn("sh /home/scripts/start_nginx.sh")
		flash[:notice] = "Start success!"
		redirect_to controller: "home", action: "index"
	end

	def stop
		@system = Sys.find_by_id(params[:id])
		@ip = Ip.find_by_id(@system.ip_id)
		ssl_conn("sh /home/scripts/stop_nginx.sh")
		flash[:notice] = "Stop Success!"
		redirect_to controller: "home", action: "index"
	end

	private

	def ssl_conn(command_string)
		begin
			client = TCPSocket.new(@ip.ip_addr, 8888)
			temp = ""
			5.times do
				temp << client.gets
			end
			public_key = OpenSSL::PKey::RSA.new(temp)
			msg = command_string
			#sha1 = Digest::SHA1.hexdigest(msg)
			command = public_key.public_encrypt("#{msg}")
			#command = public_key.public_encrypt("#{sha1}*#{msg}")
			client.send(command, 0)
		rescue => e
			puts e
			retry
			client.close
		end
	end

end
