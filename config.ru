require_relative 'config/environment.rb'
require_all 'app'

use Rack::MethodOverride

run ApplicationController
