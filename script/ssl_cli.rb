require 'socket'
require 'digest/sha1'
require "openssl"

begin
  print "Starting client......"
  client = TCPSocket.new('localhost', 8888)

  puts "connected!\n\n"

  temp = ""
  6.times do
    temp << client.gets
  end

  puts "Received public 1024 RSA key!\n\n"
  public_key = OpenSSL::PKey::RSA.new(temp)

  p public_key
	msg = 'sh /home/script/stop_nginx.sh'
  sha1 = Digest::SHA256.hexdigest(msg)

  command = public_key.public_encrypt("#{sha1}*#{msg}")
  print "Sending the command...."

  client.send(command,0)

  puts "sent!"
rescue => e
  puts "Something terrible happened..."
  puts e
  retry
end

client.close
