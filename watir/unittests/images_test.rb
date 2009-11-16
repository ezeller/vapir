# feature tests for Images
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'
require 'ftools'
require 'webrick'
require 'watir/cookiemanager'

class TC_Images < Test::Unit::TestCase
  tags :must_be_visible, :creates_windows
  include Watir
  
  def setup
    goto_page "images1.html"
    @saved_img_path = build_path("sample.img.dat");
    clean_saved_image
  end
  
  def teardown
    clean_saved_image
  end
  
  def test_imageExists
    assert_false(browser.image(:name , "missing_name").exists?)
    assert(    browser.image(:name , "circle").exists?  )
    assert(    browser.image(:name , /circ/ ).exists?  )
    
    assert_false(browser.image(:id , "missing_id").exists?)
    assert(    browser.image(:id , "square").exists?  )
    assert(    browser.image(:id , /squ/ ).exists?  )
    
    assert_false(browser.image(:src, "missingsrc.gif").exists?)
    
    assert(    browser.image(:src, "file:///#{$myDir}/html/images/triangle.jpg").exists?  )
    assert(    browser.image(:src , /triangle/ ).exists?  )
    
    assert(    browser.image(:alt , "circle" ).exists?  )
    assert(    browser.image(:alt , /cir/ ).exists?  )
    
    assert_false(browser.image(:alt , "triangle" ).exists?)
    assert_false(browser.image(:alt , /tri/ ).exists?)
    
    assert(    browser.image(:title, 'square_image').exists? )
    assert_false(browser.image(:title, 'pentagram').exists?)
  end
  
  def test_image_click
    assert_raises(UnknownObjectException) { browser.image!(:name, "no_image_with_this").click }
    assert_raises(UnknownObjectException) { browser.image!(:id, "no_image_with_this").click }
    assert_raises(UnknownObjectException) { browser.image!(:src, "no_image_with_this").click}
    assert_raises(UnknownObjectException) { browser.image!(:alt, "no_image_with_this").click}
    
    # test for bug 1882
    browser.text_field!(:name , "text1").clear
    browser.button!(:value , /Pos/ ).click
    assert_equal('clicked' , browser.text_field!(:name , "text1" ).value )
    
    # test for disabled button
    assert( ! browser.image!(:name , 'disabler_test').disabled )
    browser.button!(:name , 'disable_img').click
    
    assert( browser.image!(:name , 'disabler_test').disabled )
    browser.button!(:name , 'disable_img').click
    
    browser.image!(:src, /button/).click
    assert(browser.text.include?("PASS") )
  end
  
  def test_imageHasLoaded
    assert_raises(UnknownObjectException) { browser.image!(:name, "no_image_with_this").loaded? }
    assert_raises(UnknownObjectException) { browser.image!(:id, "no_image_with_this").loaded? }
    assert_raises(UnknownObjectException) { browser.image!(:src, "no_image_with_this").loaded? }
    assert_raises(UnknownObjectException) { browser.image!(:alt, "no_image_with_this").loaded? }
    
    assert( ! browser.image!(:name, "themissingimage").hasLoaded?  )
    assert( browser.image!(:name, "circle").hasLoaded?  )
    
    assert( browser.image!(:alt, "circle").loaded?  )
    assert( browser.image!(:alt, /cir/ ).loaded?  )
  end
  
  def test_image_properties
    assert_raises(UnknownObjectException) { browser.image!(:name, "no_image_with_this").loaded? }
    assert_raises(UnknownObjectException) { browser.image!(:id, "no_image_with_this").loaded? }
    assert_raises(UnknownObjectException) { browser.image!(:src, "no_image_with_this").loaded? }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).loaded? }
    
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).name }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).id }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).src }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).value }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).height }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).width }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).fileCreatedDate }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).fileSize }
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).alt}
    assert_raises(UnknownObjectException) { browser.image!(:index, 82).title}
    
    assert_equal( ""       , browser.image!(:index, 2).name ) 
    assert_equal( "square" , browser.image!(:index, 2).id )
    assert_match( /square\.jpg/i ,browser.image!(:index, 2).src )
    #assert_equal( "" , browser.image!(:index, 2).value )
    assert_equal( 88 , browser.image!(:index, 2).height )
    assert_equal( 88 , browser.image!(:index, 2).width )
    
    # this line fails, as the date is when it is installed on the local oc, not the date the file was really created
    #assert_equal( "03/10/2005" , browser.image!(:index, 2).fileCreatedDate )
    assert_equal( "788",  browser.image!(:index, 2).fileSize )
    
    # tool tips: alt text + title
    assert_equal('circle' , browser.image!(:index, 6).alt) 
    assert_equal( ""      , browser.image!(:index, 2).alt) 
    assert_equal('square_image', browser.image!(:id, 'square').title)
    
    # TODO: to string tests -- output should be verified!
    browser.image!(:name  , "circle").to_s
    browser.image!(:index , 2).to_s
  end
  
  def test_image_iterator
    assert_equal(6 , browser.images.length)
    assert_equal("" , browser.images[2].name )
    assert_equal("square", browser.images[2].id )
    assert_match(/square/, browser.images[2].src )
    
    index = 1
    browser.images.each do |i|
      assert_equal( browser.image!(:index, index).id , i.id )
      assert_equal( browser.image!(:index, index).name , i.name )
      assert_equal( browser.image!(:index, index).src , i.src )
      assert_equal( browser.image!(:index, index).height , i.height )
      assert_equal( browser.image!(:index, index).width , i.width )
      
      index += 1
    end
    assert_equal(index - 1 , browser.images.length)
  end
  
  def test_save_local_image
    browser.images[1].save(build_windows_path("sample.img.dat"))
    assert(File.compare(@saved_img_path, browser.images[1].src.gsub(/^file:\/\/\//, '')))
  end
  
  def clean_saved_image
    File.delete(@saved_img_path) if (File.exists?(@saved_img_path))
  end
  
  def build_windows_path(part) 
    build_path(part).gsub(/\//, "\\")
  end
  
  def build_path(part) 
    "#{$myDir}/#{part}"
  end
end

