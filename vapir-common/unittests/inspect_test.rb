$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_Inspect < Test::Unit::TestCase
  location __FILE__

  def setup
    uses_page "emphasis.html"
  end

# these tests seems rather silly to me 

  def test_inspect_only_returns_url_and_title
    assert_match(%r{#<#{browser.class}:0x[0-9a-f.]+ url="file://.+/emphasis\.html" title="emphasis">}, browser.inspect)
  end

  def test_element_inspect
    assert_match(%r{^#<.+Em:0x[0-9a-f]+ how=:attributes what=\{:id=>/em-one/\}.*>$}, browser.em(:id, /em-one/).inspect)

    located = browser.em(:id, "em-one")
    assert_true located.exists?

    assert_match(%r{^#<.+Em:0x[0-9a-f]+ how=:attributes what=\{:id=>"em-one"\}.*>$}, located.inspect)
  end

  def test_element_collections_inspect
    assert_match(%r{^#<Vapir::ElementCollection.*#<.*Em:0x[0-9a-f]+.*>.*$}, browser.ems.inspect)
  end

end

