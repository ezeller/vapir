# feature tests for modal web dialog support
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..') unless $SETUP_LOADED
require 'unittests/setup'
require 'vapir-ie/close_all'

class TC_ModalDialog < Vapir::TestCase
  include Vapir
  
  def setup
    @original_timeout = IE.attach_timeout
    goto_page 'modal_dialog_launcher.html'
    IE.attach_timeout = 10.0
  end

  def teardown 
    if browser 
      while browser.close_modal do; end
    end
    sleep 0.1
    IE.attach_timeout = @original_timeout
  end

  def assert_no_modals
    IE.attach_timeout = 0.2 
    begin
      assert_raises(NoMatchingWindowFoundException) do
        browser.modal_dialog!
      end
    ensure
      IE.attach_timeout = @original_timeout
    end
  end 
     
  def test_modal_simple_use_case
    browser.button!(:value, 'Launch Dialog').click_no_wait
    modal = browser.modal_dialog.document

    assert(modal.text.include?('Enter some text:'))
    modal.text_field!(:name, 'modal_text').set('hello')
    modal.button!(:value, 'Close').click
    assert_equal('hello', browser.text_field!(:name, 'modaloutput').value)
  end

  def test_wait_should_not_block
    browser.button!(:value, 'Launch Dialog').click_no_wait
    modal = browser.modal_dialog.document

    modal.text_field!(:name, 'modal_text').set('hello')
    modal.wait

    modal.button!(:value, 'Close').click
  end

  def test_modal_dialog_use_case_default
    browser.button!(:value, 'Launch Dialog').click_no_wait

    modal = browser.modal_dialog
    assert_not_nil modal

    # Make sure that we have attached to modal and that the hwnd method
    # is working properly to show the HWND of our parent.
    assert_not_equal(browser.hwnd, modal.hwnd)

    # Once attached just treat the modal_dialog like any IE or Frame
    # object.
    modal_document=modal.document
    assert(modal_document.text.include?('Enter some text:'))
    modal_document.text_field!(:name, 'modal_text').set('hello')
    modal_document.button!(:value, 'Close').click

    assert_no_modals
    assert_equal('hello', browser.text_field!(:name, 'modaloutput').value)
  end

  # Now explicitly supply the :title parameter.
  def test_modal_dialog_use_case_title
    browser.button!(:value, 'Launch Dialog').click_no_wait

    modal = browser.modal_dialog
    assert_not_equal(browser.hwnd, modal.hwnd)
    
    modal_document=modal.document

    assert_equal('Modal Dialog', modal_document.title)

    assert(modal_document.text.include?('Enter some text:'))
    modal_document.button!(:value, 'Close').click
  end

  # Now explicitly supply the :title parameter with regexp match
  def test_modal_dialog_use_case_title_regexp
    assert_raises(ArgumentError){browser.modal_dialog(:title, /dal Dia/)}
  end

  # Now explicitly supply an invalid "how" value
  def test_modal_dialog_use_case_invalid
    assert_raise(ArgumentError) { browser.modal_dialog(:esp) }
  end

  def test_double_modal
    browser.button!(:value, 'Launch Dialog').click_no_wait
    modal1 = browser.modal_dialog.document
    modal1.button!(:text, 'Another Modal').click_no_wait
    modal2 = modal1.modal_dialog.document
    assert_equal modal2.title, 'Pass Page'
    modal2.close
    modal1.close
  end
  
  def xtest_modal_with_frames
    browser.button!(:value, 'Launch Dialog').click_no_wait
    modal1 = browser.modal_dialog.document
    modal1.button!(:value, 'Modal with Frames').click_no_wait
    modal2 = browser.modal_dialog.document
    modal2.frame!('buttonFrame').button!(:value, 'Click Me').click
    assert(modal2.frame!('buttonFrame').text.include?('PASS'))
    modal2.frame!('buttonFrame').button!(:value, 'Close Window').click
    modal1.close
  end
  
  def test_modal_exists
    browser.button!(:value, 'Launch Dialog').click_no_wait
    modal = browser.modal_dialog.document
    assert(modal.exists?)
    modal.button!(:value, 'Close').click
    assert_false(modal.exists?)
  end
        
end
