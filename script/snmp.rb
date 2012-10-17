#!/usr/bin/env ruby

require 'active_record'
require 'snmp'
include SNMP

ActiveRecord::Base.establish_connection(
	adapter: "mysql2",
	database: "system",
	host: "0.0.0.0",
	username: "minix",
	password: "12345678c9",
)

class Sys < ActiveRecord::Base
end

status_code = Sys.new

host = ARGV[0] || 'localhost'
oid_value = Array.new

manager = Manager.new(:Host => host, :Community => 'public', :Port => 161, :Version => :SNMPv2c)
new_oid = ObjectId.new("1.3.6.1.4.1.2021.3275.5327.3.1.1.12.110.103.105.110.120.95.115.116.97.116.117.115")
next_oid = new_oid 
while next_oid.subtree_of?(new_oid)      #Returns true if this ObjectId is a subtree of the provided parent tree ObjectId. For example, 1.3.6.1.5 is a subtree of 1.3.6.1
	response = manager.get_next(next_oid)  #get oid next get request value
	varbind = response.varbind_list.first
	next_oid = varbind.name
	find_oid = Sys.find( :first, conditions: { oid: "#{new_oid}" })
	find_oid.update_attributes( status: "#{varbind.value.to_s}" )
end

