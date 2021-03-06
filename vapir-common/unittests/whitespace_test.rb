# feature tests for white space

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_WhiteSpace < Test::Unit::TestCase
  location __FILE__

  def setup
    uses_page "whitespace.html"
  end 

  def test_text_with_nbsp
    # firefox returns the unicode \302\240 whereas ie returns a space. 
    assert_match(/\A[\302\240 ]Login[\302\240 ]\z/u, browser.link!(:index => 1).text)
  end

  def test_nbsp_beginning_and_end
    assert browser.link(:text, /Login/).exists?
  end
  
  def test_single_nbsp
    # firefox returns the unicode \302\240 whereas ie returns a space. 
    assert_match(/\A\s*Test for[\302\240 ]nbsp\.\s*\z/u, browser.span!(:id, 'single_nbsp').text)
  end
  
  def test_multiple_spaces
    assert_match(/\A\s*Test for multiple *spaces\.\s*\z/, browser.span!(:id, 'multiple_spaces').text)
  end
  
  def test_multiple_spaces_access
    assert_equal 'multiple_spaces', browser.span!(:text, /Test +for +multiple +spaces./).id
  end
  
  def test_space_tab
    assert_match(/\A\s*Test for *space and tab\.\s*\z/, browser.span!(:id, 'space_tab').text)
  end
  
  def test_space_w_cr
    assert_match(/\A\s*Test for space and\s*cr\.\s*\z/, browser.span!(:id, 'space_w_cr').text)
  end
end
