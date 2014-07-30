# test/Stateful.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

test_dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift(test_dir) unless $LOAD_PATH.include?(test_dir)

lib_dir = File.expand_path(File.join(test_dir, '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

active_record_specs = Dir[File.join(test_dir, 'ActiveRecord', '**', '*.rb')]
active_record_specs.each{|spec| require spec}

poro_specs = Dir[File.join(test_dir, 'Poro', '**', '*.rb')]
poro_specs.each{|spec| require spec}
