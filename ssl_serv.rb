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
    puts "Connection made...sending public key.\n\n"
    puts pub_key
    session.print pub_key
    puts "Public key sent, waiting on data...\n\n"

    temp = session.recv(10000)
    puts "Received data..."

    msg = priv_key.private_decrypt(temp)
  rescue => e
    puts "Something terrible happened while receiving and decrypting."
    puts e
  end

  command = msg.split("*")
  serv_hash = command[0]
  nix_app = command[1]

 	if Digest::SHA256.hexdigest("#{nix_app}") == serv_hash
    puts "Message integrity confirmed..."
    puts "Executing command: #{nix_app}"
    `#{nix_app}`
    exit
  else
    puts "The message could not be validated!"
  end
  exit
end
