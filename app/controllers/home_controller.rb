require 'ipaddr'
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

	end

	def stop

	end

	private
	def real_ip(ip)
		new_ip = IPAddr.new(ip).to_i
		return new_ip
	end
end
