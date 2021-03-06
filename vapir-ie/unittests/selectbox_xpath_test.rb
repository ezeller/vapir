# feature tests for Select Boxes
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_Selectbox_XPath < Test::Unit::TestCase
  include Vapir::Exception
  
  def setup
    goto_page "selectboxes1.html"
  end
  
  def test_textBox_Exists
    assert(browser.select_list(:xpath, "//select[@name='sel1']/").exists?)
    assert_false(browser.select_list(:xpath, "//select[@name='missing']/").exists?)
    assert_false(browser.select_list(:xpath, "//select[@id='missing']/").exists?)
  end
  
  def test_select_list_enabled
    assert(browser.select_list!(:xpath, "//select[@name='sel1']/").enabled?)
    assert_raises(UnknownObjectException) { browser.select_list(:xpath, "//select[@name='NoName']/").enabled? }
  end
  
  def test_select_list_option_texts
    assert_raises(UnknownObjectException) { browser.select_list(:xpath, "//select[@name='NoName']/").option_texts }
    assert_equal( ["Option 1" ,"Option 2" , "Option 3" , "Option 4"] , 
    browser.select_list!(:xpath, "//select[@name='sel1']/").option_texts)
  end
  
  def test_select_list_selected_option_texts
    assert_raises(UnknownObjectException) { browser.select_list(:xpath, "//select[@name='NoName']/").selected_option_texts }
    assert_equal( ["Option 3" ] , 
    browser.select_list!(:xpath, "//select[@name='sel1']/").selected_option_texts)
    assert_equal( ["Option 3" , "Option 6" ] , 
    browser.select_list!(:xpath, "//select[@name='sel2']/").selected_option_texts)
  end
  
  def test_clearSelection
    assert_raises(UnknownObjectException) { browser.select_list(:xpath, "//select[@name='NoName']/").clearSelection }
    browser.select_list!(:xpath, "//select[@name='sel1']/").clearSelection
    
    # the box sel1 has no ability to have a de-selected item
    assert_equal( ["Option 3" ] , browser.select_list!(:xpath, "//select[@name='sel1']/").selected_option_texts)
    
    browser.select_list!(:xpath, "//select[@name='sel2']/").clearSelection
    assert_equal( [ ] , browser.select_list!(:xpath, "//select[@name='sel2']/").selected_option_texts)
  end
  
  def test_select_list_select
    assert_raises(UnknownObjectException) { browser.select_list(:xpath, "//select[@name='NoName']/").selected_option_texts }
    assert_raises(NoValueFoundException) { browser.select_list!(:xpath, "//select[@name='sel1']/").select("missing item") }
    assert_raises(NoValueFoundException) { browser.select_list!(:xpath, "//select[@name='sel1']/").select(/missing/) }
    
    # the select method keeps any currently selected items - use the clear selectcion method first
    browser.select_list!(:xpath, "//select[@name='sel1']/").clearSelection
    browser.select_list!(:xpath, "//select[@name='sel1']/").select("Option 1")
    assert_equal( ["Option 1" ] , browser.select_list!(:xpath, "//select[@name='sel1']/").selected_option_texts)
    
    browser.select_list!(:xpath, "//select[@name='sel1']/").clearSelection
    browser.select_list!(:xpath, "//select[@name='sel1']/").select(/2/)
    assert_equal( ["Option 2" ] , browser.select_list!(:xpath, "//select[@name='sel1']/").selected_option_texts)
    
    browser.select_list!(:xpath, "//select[@name='sel2']/").clearSelection
    browser.select_list!(:xpath, "//select[@name='sel2']/").select( /2/ )
    browser.select_list!(:xpath, "//select[@name='sel2']/").select( /4/ )
    assert_equal( ["Option 2" , "Option 4" ] , 
    browser.select_list!(:xpath, "//select[@name='sel2']/").selected_option_texts)
    
    # these are to test the onchange event
    # the event shouldnt get fired, as this is the selected item
    browser.select_list!(:xpath, "//select[@name='sel3']/").select( /3/ )
    assert_false(browser.text.include?("Pass") )
  end
  
  def test_select_list_select2
    # the event should get fired
    browser.select_list!(:xpath, "//select[@name='sel3']/").select( /2/ )
    assert(browser.text.include?("PASS") )
  end
  
  def test_select_list_select_using_value
    assert_raises(UnknownObjectException) { browser.select_list(:xpath, "//select[@name='NoName']/").selected_option_texts }
    assert_raises(NoValueFoundException) { browser.select_list!(:xpath, "//select[@name='sel1']/").select_value("missing item") }
    assert_raises(NoValueFoundException) { browser.select_list!(:xpath, "//select[@name='sel1']/").select_value(/missing/) }
    
    # the select method keeps any currently selected items - use the clear selectcion method first
    browser.select_list!(:xpath, "//select[@name='sel1']/").clearSelection
    browser.select_list!(:xpath, "//select[@name='sel1']/").select_value("o1")
    assert_equal( ["Option 1" ] , browser.select_list!(:xpath, "//select[@name='sel1']/").selected_option_texts)
    
    browser.select_list!(:xpath, "//select[@name='sel1']/").clearSelection
    browser.select_list!(:xpath, "//select[@name='sel1']/").select_value(/2/)
    assert_equal( ["Option 2" ] , browser.select_list!(:xpath, "//select[@name='sel1']/").selected_option_texts)
    
    browser.select_list!(:xpath, "//select[@name='sel2']/").clearSelection
    browser.select_list!(:xpath, "//select[@name='sel2']/").select( /2/ )
    browser.select_list!(:xpath, "//select[@name='sel2']/").select( /4/ )
    assert_equal( ["Option 2" , "Option 4" ] , browser.select_list!(:xpath, "//select[@name='sel2']/").selected_option_texts)
    
    # these are to test the onchange event
    # the event shouldnt get fired, as this is the selected item
    browser.select_list!(:xpath, "//select[@name='sel3']/").select_value( /3/ )
    assert_false(browser.text.include?("Pass") )
  end
  
  def test_select_list_select_using_value2
    # the event should get fired
    browser.select_list!(:xpath, "//select[@name='sel3']/").select_value( /2/ )
    assert(browser.text.include?("PASS") )
  end
  
end
