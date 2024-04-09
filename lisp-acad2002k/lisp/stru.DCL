@include "setprop.dcl"

stlg_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"º¸";
        key = "rd_stlg";
    }
    : radio_button {
        label = /*MSG5*/"Áß½É¼±";
        key = "rd_cen";
    }
   
}

dd_stlg:dialog{
	label="Æò¸é º¸ ±×¸®±â";	
	: boxed_column {
	label = "¼Ó¼º";
	properties;
	stlg_prop_radio;
	}
	: boxed_row{
		label = /*MSG8*/"º¸ µÎ²² ¼³Á¤:";
		: edit_box_8 {
		        key = "eb_stlg_width";
		        label = /*MSG8*/"º¸ÀÇ µÎ²² :";
	        }
	       	: edit_box_8 {
		        key = "eb_stlg_offset";
		        label = /*MSG8*/"Offset :"; 
	        }
        
        }
	ok_cancel_err;
}
dd_column:dialog{
	label="Æò¸é ±âµÕ ±×¸®±â";	
	: boxed_column {
	label = "Æ¯¼º";
	properties;
	}
	: boxed_row{
	label="±âµÕ Å¸ÀÔ";	
	  :radio_row {
	    key = "col_type";
	    : radio_button {
	        label = /*MSG5*/"RC";
	        key = "col_type_Rc";
	    }
	    : radio_button {
	        label = /*MSG5*/"SRC";
	        key = "col_type_Src";
	    }
   	   : radio_button {
	        label = /*MSG5*/"STEEL";
	        key = "col_type_sTeel";
	    }
	  }  
	}
	: boxed_column{
	label = /*MSG8*/"±âµÕ Å©±â ¼³Á¤:";
	:row {
		: edit_box_8 {
	        key = "eb_col_width";
	        label = /*MSG8*/"±âµÕ Æø:";
	         
	        }
	        : edit_box_8 {
	        key = "eb_col_length";
	        label = /*MSG8*/"±âµÕ ³Êºñ:";
	         
	        }
        }
        :row {
		: edit_box_8 {
	        key = "eb_stl_width";
	        label = /*MSG8*/"Hºö Æø:";
	         
	        }
	        : edit_box_8 {
	        key = "eb_stl_length";
	        label = /*MSG8*/"Hºö ³Êºñ:";
	         
	        }
        }
//        :row {
//		: edit_box_8 {
//	        key = "eb_stl_xoff";
//	        label = /*MSG8*/"Hºö Æø:";
//	         
//	        }
//	        : edit_box_8 {
//	        key = "eb_stl_yoff";
//	        label = /*MSG8*/"Hºö ³Êºñ:";
//	         
//	        }
//        }
        
        }
	ok_cancel_err;
}
//Width(lx) of Column<600>:
//Length(ly) of Column<600>:
//Distance from Ref.Pt to right side of Column<300>:
//Distance from Ref.Pt to upper side of Column<300>:
//Width(lx) of H-STL. Column<400>:
//Length(ly) of H-STL. Column<400>: