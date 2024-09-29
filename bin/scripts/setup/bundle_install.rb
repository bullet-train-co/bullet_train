require File.expand_path("../utils", __dir__)

announce_section 'Bundler setup'

system! 'gem install bundler --conservative'
system('bundle check') || system!('bundle install')
