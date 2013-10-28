# Make sure our default RACK_ENV is development if it has not been set
# by the global environment.
ENV['RACK_ENV'] ||= 'development'

# Load our environment.
require './config/environment'

# A method to quickly mount all our Controllers as Middleware
def mount_controllers_as_middleware
  Dir.entries('app/controllers').each do |file|
    next if file.start_with?(".") || file == "application_controller.rb"
    controller_name = file.split("_controller").first.capitalize
    use Kernel.const_get("#{controller_name}Controller")
  end
end
mount_controllers_as_middleware

log = File.new("log/#{ENV["RACK_ENV"]}.log", "w")
STDOUT.reopen(log)
STDERR.reopen(log)

use Rack::Static, :root => 'public', :urls => ['/']
use Rack::CommonLogger


# Mount the main controller as our Rack Application.
run ApplicationController