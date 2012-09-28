require 'socket'
require 'digest/sha1'
require "openssl"

RE = %r/(?:[^:\-]|\A)(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F](?:[^:\-]|\Z)/io
platform = RUBY_PLATFORM.downcase
output = `#{platform =~ /linux/ ? '/sbin/ifconfig' : 'ifconfig'}`

def parse(output)
	lines = output.split(/\n/)
	candidates = lines.select{|line| line =~ RE}
	raise 'no mac address candidates' unless candidates.first
	candidates.map!{|c| c[RE].strip}
end

begin
  print "Starting client......"
  client = TCPSocket.open('localhost', 8888)

  puts "connected!\n\n"

	macaddr = parse(output)
	client.print macaddr
  temp = ""
  6.times do
    temp << client.gets
  end

  puts "Received public 1024 RSA key!\n\n"
  public_key = OpenSSL::PKey::RSA.new(temp)

  p public_key
	msg = 'echo \"hello\"'

  command = public_key.public_encrypt("#{msg}")
  print "Sending the command...."

  client.send(command,0)

  puts "sent!"
rescue => e
  puts "Something terrible happened..."
  puts e
  retry
end

client.close
