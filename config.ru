require_relative './config/environment'

use Rack::MethodOverride

# use HelperController
use RecipeController
use UserController
run ApplicationController
