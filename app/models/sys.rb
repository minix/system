class Sys < ActiveRecord::Base
  attr_accessible :ip_addr, :port, :service, :status
end
