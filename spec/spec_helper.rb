require 'coveralls'
Coveralls.wear!


$LOAD_PATH << '../lib'

RSpec.configure do |config|
  config.order = 'random'
end
