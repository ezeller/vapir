# feature tests for Check Boxes
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') if $0 == __FILE__
require 'unittests/setup'

class TC_CheckBox < Test::Unit::TestCase
    include Watir

    def setup()
        $ie.goto($htmlRoot + "checkboxes1.html")
    end

    def test_checkbox_properties


       assert_raises(UnknownObjectException , "UnknownObjectException was supposed to be thrown" ) {   $ie.checkbox(:name, "noName").id   }  
       assert_raises(UnknownObjectException , "UnknownObjectException was supposed to be thrown" ) {   $ie.checkbox(:name, "noName").name   }  
       assert_raises(UnknownObjectException , "UnknownObjectException was supposed to be thrown" ) {   $ie.checkbox(:name, "noName").disabled   }  
       assert_raises(UnknownObjectException , "UnknownObjectException was supposed to be thrown" ) {   $ie.checkbox(:name, "noName").type   }  
       assert_raises(UnknownObjectException , "UnknownObjectException was supposed to be thrown" ) {   $ie.checkbox(:name, "noName").value   }  

       assert_equal("box1"  , $ie.checkbox(:index, 1).name  ) 
       assert_equal(""  , $ie.checkbox(:index, 1).id  ) 
       assert_equal("checkbox"  , $ie.checkbox(:index, 1).type  ) 
       assert_equal("on"  , $ie.checkbox(:index, 1).value  ) 
       assert_equal(false  , $ie.checkbox(:index, 1).disabled  ) 

       assert_equal("1" , $ie.checkbox(:name,"box4").value )
       assert_equal("3" , $ie.checkbox(:name,"box4" , 3).value )
       assert_equal("checkbox" , $ie.checkbox(:name,"box4" , 3).type )
       assert_equal(false , $ie.checkbox(:name,"box4" , 3).disabled )
       assert_equal("" , $ie.checkbox(:name,"box4" , 3).id )

    end


    def test_onClick
       assert_false($ie.button("foo").enabled?)
       $ie.checkBox(:name, "box5").set
       assert($ie.button("foo").enabled?)

       $ie.checkBox(:name, "box5").clear
       assert_false($ie.button("foo").enabled?)
    end

    def test_CheckBox_Exists
       assert($ie.checkBox(:name, "box1").exists?)   
       assert_false($ie.checkBox(:name, "missing").exists?)   

       assert($ie.checkbox(:name, "box4" , 1).exists?)   
       assert_false($ie.checkbox(:name, "box4" , 22).exists?)   
    end

    def test_checkbox_Enabled
       assert_raises(UnknownObjectException) { $ie.checkbox(:name, "noName").enabled? }  
       assert_raises(UnknownObjectException) { $ie.checkbox(:id, "noName").enabled? }  
       assert_raises(UnknownObjectException) { $ie.checkbox(:name, "box4" , 6).enabled? }  

       assert($ie.checkbox(:name, "box1").enabled?)   
       assert_false($ie.checkbox(:name, "box2").enabled?)   

       assert($ie.checkbox(:name, "box4" , 4).enabled?)   
       assert_false($ie.checkbox(:name, "box4" , 5 ).enabled?)   
    end

    def test_checkbox_isSet
       assert_raises(UnknownObjectException ) { $ie.checkbox(:name, "noName").isSet? }  

       assert_false($ie.checkbox(:name, "box1").isSet?)   
       assert_false($ie.checkbox(:name, "box2").isSet?)   
       assert($ie.checkbox(:name, "box3").isSet?)   

       assert_false($ie.checkbox(:name, "box4" , 2 ).isSet?)   
       assert($ie.checkbox(:name, "box4" , 1 ).isSet?)   
    end

    def test_checkbox_clear
       assert_raises(UnknownObjectException) { $ie.checkbox(:name, "noName").clear }  
       $ie.checkbox(:name, "box1").clear
       assert_false($ie.checkbox(:name, "box1").isSet?)   

       assert_raises(ObjectDisabledException) { $ie.checkbox(:name, "box2").clear } 
       assert_false($ie.checkbox(:name, "box2").isSet?)   

       $ie.checkbox(:name, "box3").clear
       assert_false($ie.checkbox(:name, "box3").isSet?)   

       $ie.checkbox(:name, "box4" , 1).clear
       assert_false($ie.checkbox(:name, "box4" , 1).isSet?)   
    end

    def test_checkbox_getState
       assert_raises(UnknownObjectException) { $ie.checkbox(:name, "noName").getState }  
       assert_equal( false , $ie.checkbox(:name, "box1").getState )   
       assert_equal( true , $ie.checkbox(:name, "box3").getState)   

       # checkboxes that have the same name but different values
       assert_equal( false , $ie.checkbox(:name, "box4" , 2).getState )   
       assert_equal( true , $ie.checkbox(:name, "box4" , 1).getState)   
    end

    def test_checkbox_set
       assert_raises(UnknownObjectException) { $ie.checkbox(:name, "noName").set }  
       $ie.checkbox(:name, "box1").set
       assert($ie.checkbox(:name, "box1").isSet?)   

       assert_raises(ObjectDisabledException) { $ie.checkbox(:name, "box2").set }  

       $ie.checkbox(:name, "box3").set
       assert($ie.checkbox(:name, "box3").isSet?)   

       # checkboxes that have the same name but different values
       $ie.checkbox(:name, "box4" , 3).set
       assert($ie.checkbox(:name, "box4" , 3).isSet?)   
    end
end