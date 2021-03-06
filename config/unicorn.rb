require 'tmpdir'

# Load app.rb to get all dependencies.
require 'app.rb'

# Make sure elasticsearch is configured correctly
UnicornHelpers.exit_on_invalid_index

worker_processes Integer(ENV['WORKER_PROCESSES'] || 4)
timeout 25
preload_app true
data_dir = ENV['DATA_DIR'] || Dir.tmpdir
listen "unix:#{data_dir}/forum.sock", :backlog => 512
pid "#{data_dir}/forum_unicorn.pid"

after_fork do |server, worker|
  ::Mongoid.default_client.close
end
