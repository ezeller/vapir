# vapir-ie/unittests/setup.rb
$SETUP_LOADED = true

$myDir = File.expand_path(File.dirname(__FILE__))

def append_to_load_path path
  $LOAD_PATH.unshift File.expand_path(path)
end

# use local development versions of vapir-ie, vapir-firefox, vapir-common if available
topdir = File.join(File.dirname(__FILE__), '..')
$firewatir_dev_lib = File.join(topdir, '..', 'vapir-firefox', 'lib')
$watir_dev_lib = File.join(topdir, 'lib')
libs = []
libs << File.join(topdir, '..', 'vapir-common', 'lib')
libs << File.join(topdir, '..', 'vapir-common') # for the unit tests
libs.each { |lib| append_to_load_path(lib) }

require 'vapir-common/browser'
Vapir::Browser.default = 'ie'
require 'unittests/setup/lib'
require 'vapir-common/testcase'

# Standard Tags
# :must_be_visible
# :creates_windows
# :unreliable (test fails intermittently)

=begin
Test Suites
* all_tests -- all the tests in the unittests directory (omits "other")
* window_tests -- window intensive tests
=end

tiptopdir = File.join topdir, '..'
commondir = File.join topdir, '..', 'vapir-common'
append_to_load_path tiptopdir
$all_tests = []
Dir.chdir tiptopdir do
  $all_tests += Dir["vapir-ie/unittests/*_test.rb"]
end
Dir.chdir tiptopdir do
  $all_tests += Dir["vapir-common/unittests/*_test.rb"]
end

# These tests won't load unless Vapir is in the path
$watir_only_tests = [
  "images_xpath_test.rb",
  "images_test.rb",
  "dialog_test.rb",
  "ie_test.rb"
].map {|file| "vapir-ie/unittests/#{file}"}

if Vapir::UnitTest.options[:browser] != 'ie'
  $all_tests -= $watir_only_tests
end


=begin
     'attach_to_existing_window', # could actually run robustly as part of the core suite!
     'attach_to_new_window', # creates new window
     'close_window', # creates new window
     'frame_links', # visible
     'iedialog', # visible
     #ie-each
     'js_events', # is always visible
     'jscript',
     'modal_dialog', # modal is visible
     #new 
     'open_close',
     'send_keys', # visible
=end
Dir.chdir tiptopdir do
  $window_tests = Dir["vapir-ie/unittests/windows/*_test.rb"] - ["vapir-ie/unittests/windows/ie-each_test.rb"]
end


