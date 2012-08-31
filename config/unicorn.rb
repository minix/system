worker_processes 3

#listen '127.0.0.1:5555'
listen '/tmp/unicorn.sock'
listen '/tmp/unicorn1.sock'
listen '/tmp/unicorn2.sock'

stderr_path File.expand_path('/tmp/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('/tmp/unicorn.log', ENV['RAILS_ROOT'])
pid File.expand_path('/tmp/unicorn.pid', ENV['RAILS_ROOT'])

preload_app true

before_fork do |server, worker|
	defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
	old_pid = "#{server.config[:pid]}.oldbin"
	unless old_pid == server.pid
		begin 
			Process.kill :QUIT, File.read(old_pid).to_i
		rescue Errno::ENOENT, Errno::ESRCH
		end
	end
end
after_fork do |server, worker| 
	defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection 
end
