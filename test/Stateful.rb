# test/Stateful.rb

# 20140112
# 0.5.0

require 'Version'
require 'Kernel/require_relative' if Version.new(RUBY_VERSION) < '1.9'
# require 'minitest/autorun'

require_relative '../lib/Stateful'

def test_files
  Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), '*.rb'))) - [File.expand_path(__FILE__)]
end

test_files.each do |test_file|
  puts test_file
  system "ruby #{test_file}"
end
