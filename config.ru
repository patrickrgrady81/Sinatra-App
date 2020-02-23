require_relative './config/environment'

use Rack::MethodOverride

use RecipeController
run ApplicationController
