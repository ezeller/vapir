# feature tests for Text Fields
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') if $0 == __FILE__
require 'unittests/setup'

class TC_Fields < Test::Unit::TestCase
    include Watir

    def setup()
        $ie.goto($htmlRoot + "textfields1.html")
    end

    def test_textField_Exists
       assert($ie.textField(:name, "text1").exists?)   
       assert_false($ie.textField(:name, "missing").exists?)   

       assert($ie.textField(:id, "text2").exists?)   
       assert_false($ie.textField(:id, "alsomissing").exists?)   

        assert($ie.textField(:beforeText , "This Text After").exists? )
        assert($ie.textField(:afterText , "This Text Before").exists? )

        assert($ie.textField(:beforeText , /after/i).exists? )
        assert($ie.textField(:afterText , /before/i).exists? )




    end

    def atest_textField_dragContentsTo

        $ie.textField(:name, "text1").dragContentsTo(:id, "text2")
        assert_equal($ie.textField(:name, "text1").getContents, "" ) 
        assert_equal($ie.textField(:id, "text2").getContents, "goodbye allHello World" ) 

    end


    def atest_textField_VerifyContents
       assert($ie.textField(:name, "text1").verify_contains("Hello World") )  
       assert($ie.textField(:name, "text1").verify_contains(/Hello\sW/ ) )  
       assert_false($ie.textField(:name, "text1").verify_contains("Ruby") )  
       assert_false($ie.textField(:name, "text1").verify_contains(/R/) )  
       assert_raises(UnknownObjectException , "UnknownObjectException was supposed to be thrown" ) {   $ie.textField(:name, "NoName").verify_contains("No field to get a value of") }  

       assert($ie.textField(:id, "text2").verify_contains("goodbye all") )  
       assert_raises(UnknownObjectException , "UnknownObjectException was supposed to be thrown" ) {   $ie.textField(:id, "noID").verify_contains("No field to get a value of") }  

       



    end

    def atest_textField_enabled
       assert_false($ie.textField(:name, "disabled").enabled? )  
       assert($ie.textField(:name, "text1").enabled? )  
       assert($ie.textField(:id, "text2").enabled? )  

    end

    def atest_textField_readOnly
       assert_false($ie.textField(:name, "disabled").readOnly? )  
       assert($ie.textField(:name, "readOnly").readOnly? )  
       assert($ie.textField(:id, "readOnly2").readOnly? )  

    end


    def atest_textField_getContents()
         assert_raises(UnknownObjectException  , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:name, "missing_field").append("Some Text") }  
         assert_equal(  "Hello World" , $ie.textField(:name, "text1").getContents )  


    end

    def atest_TextField_to_s
         puts "---------------- To String test -------------"
         puts $ie.textField(:index , 1).to_s
         puts "---------------- To String test -------------"
         puts $ie.textField(:index , 2).to_s
         puts "---------------- To String test -------------"
         assert_raises(UnknownObjectException  , "UnknownObjectException  was supposed to be thrown" ) {   $ie.textField(:index, 999 ).to_s}  


 
    end


    def atest_textField_Append
         assert_raises(ObjectReadOnlyException  , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:id, "readOnly2").append("Some Text") }  
         assert_raises(ObjectDisabledException   , "ObjectDisabledException   was supposed to be thrown" ) {   $ie.textField(:name, "disabled").append("Some Text") }  
         assert_raises(UnknownObjectException  , "UnknownObjectException  was supposed to be thrown" ) {   $ie.textField(:name, "missing_field").append("Some Text") }  

         $ie.textField(:name, "text1").append(" Some Text")
         assert_equal(  "Hello World Some Text" , $ie.textField(:name, "text1").getContents )  

         # may need this to see that it really happened
         #puts "press return to continue"
         #gets 

    end


    def atest_textField_Clear
         assert_raises(ObjectReadOnlyException  , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:id, "readOnly2").append("Some Text") }  
         assert_raises(ObjectDisabledException   , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:name, "disabled").append("Some Text") }  
         assert_raises(UnknownObjectException  , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:name, "missing_field").append("Some Text") }  

         $ie.textField(:name, "text1").clear()
         assert_equal(  "" , $ie.textField(:name, "text1").getContents )  

         # may need this to see that it really happened
         #puts "press return to continue"
         #gets 

    end

    def atest_textField_Set
         assert_raises(ObjectReadOnlyException  , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:id, "readOnly2").append("Some Text") }  
         assert_raises(ObjectDisabledException   , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:name, "disabled").append("Some Text") }  
         assert_raises(UnknownObjectException  , "ObjectReadOnlyException   was supposed to be thrown" ) {   $ie.textField(:name, "missing_field").append("Some Text") }  

         $ie.textField(:name, "text1").set("watir IE Controller")
         assert_equal(  "watir IE Controller" , $ie.textField(:name, "text1").getContents )  

         # may need this to see that it really happened
         #puts "press return to continue"
         #gets 

    end

    def aaatest_adjacentTExt

        d = $ie.getIE.document.body.all
        d.each do |dd|

            begin
                if dd.invoke("type").to_s.downcase == "text"
                    puts "text afterEnd is: " + dd.getAdjacentText("afterEnd")
                    puts "text beforeBegin is: " + dd.getAdjacentText("beforeBegin")

                    puts "text beforeEnd is: " + dd.getAdjacentText("beforeEnd")
                    puts "text afterBegin is: " + dd.getAdjacentText("afterBegin")

                end
            rescue => e

                puts e if e.to_s.match(/Unknown property or method/) == nil
            end

        end 

    end


end