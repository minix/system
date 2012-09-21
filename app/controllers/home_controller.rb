require 'ipaddr'
require 'socket'
require 'digest/sha1'
require "openssl"

class HomeController < ApplicationController
	def index
		@add_dev = Ip.find :all

		if request.post?
			ssl_conn
		end
	end

	def status

	end

	def new
		@add_dev = Ip.new(params[:add_dev])
		3.times { @add_dev.syss.build }
		#@add_dev.syss.build 

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
			#msg = "sh /home/scripts/nginx_status.sh"
			msg = command_string
			sha1 = Digest::SHA1.hexdigest(msg)
			command = public_key.public_encrypt("#{sha1}*#{msg}")
			client.send(command, 0)
		rescue => e
			puts e
			retry
			client.close
		end
	end

#	def oid
#		config_file = File.open("/etc/snmp/snmpd.conf", "a+")
#		server_name = self.server
#		custom_oid = ('0'..'9').to_a.shufflt[0..3].join
#		self.oid = server_oid = ".1.3.6.1.4.2021.#{custom_oid}"
#
#		config_file << "extend #{server_oid} #{server_name} /bin/sh /home/script/#{server_name}_status.sh"
#
#		status_file = File.new("#{server_name}_status\.sh")
#		script_str = <<"EOF" 
##!/usr/bin/env sh
##
#serv_name=`pgrep #{server.server}`
#echo $?
#EOF
#	status_file << script_str
#	end
	
end
