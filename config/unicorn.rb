worker_processes 4
listen "/home/tribunals/application/shared/unicorn.sock", :backlog => 64
working_directory "/home/tribunals/application/current"
pid "/home/tribunals/application/shared/pids/unicorn.pid"
timeout 30
preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
