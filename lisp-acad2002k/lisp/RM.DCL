/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   ROOMNAME.DCL   Version 1.0
//
//   Copyright (C) 1996/8 by Korea CIM, LTD.
//      
//   Permission to use, copy, modify, and distribute this software 
//   for any purpose and without fee is hereby granted, provided 
//   that the above copyright notice appears in all copies and that 
//   both that copyright notice and this permission notice appear in 
//   all supporting documentation.
//      
//   THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED
//   WARRANTY.  ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR
//   PURPOSE AND OF MERCHANTABILITY ARE HEREBY DISCLAIMED.
//   
//----------------------------------------------------------------------------
//
// Corresponding dialogues for ROOMNAME.ARX which is an ARX implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------


@include "setprop.dcl"

//-------- Subassemblies and prototypes shared across several dialogues -------
roomname_prop : boxed_column {
    label = /*MSG2*/" 특 성";
    prop_c_la;
    room_prop_radio;
}

roomname_image : image_button {
    key = "bn_room_image";
    height       = 6;
    aspect_ratio = 1.5;
    color        = -2;
}

text_image : image {
    key = "text_image";
    height       = 6;
    aspect_ratio = 1.5;
    color        = -2;
}

room_prop_radio : radio_row {
    key = "prop_radio";
    : radio_button {
        label = /*MSG3*/"심볼";
        key = "rd_box";
    }
    : radio_button {
        label = /*MSG3*/"문자";
        key = "rd_name";
    }    
}

room_type_radio : radio_row {
    key = "rn_type_radio";        
    		: radio_button {
        		label = /*MSG3*/"1";
        		key = "rd_type1";
    		}    	
    		: radio_button {
        		label = /*MSG3*/"2";
        		key = "rd_type2";
    		}       	
    	
    		: radio_button {
        		label = /*MSG3*/"3";
        		key = "rd_type3";
    		}    
    		: radio_button {
        		label = /*MSG3*/"4";
        		key = "rd_type4";
        	}           
}

room_options : row {
    children_fixed_width = true;
	: boxed_column {
	    label = /*MSG5*/"유 형";
	    roomname_image;
	    room_type_radio;
	    : edit_box {
	        label = /*MSG20*/"실번호:";
	     	key = "ed_number";
	        edit_width = 9;
	    }
	    : edit_box {
	        label = /*MSG20*/"천정고:";
	     	key = "ed_height";
	        edit_width = 9;
	    }
	    : edit_box {
	        label = /*MSG20*/"면  적:";
	     	key = "ed_schedule";
	        edit_width = 9;
	    }
	}
	: boxed_column {
	    label = /*MSG5*/"실    명";
	    : edit_box {
	     	key = "ed_text";
	        edit_width = 21;
	    }
	    : list_box {
	        key = "list_text";
	        height = 8;
	    }
		: row {
		    : button {
		        label = /*MSG4*/"삭제";
		        key = "eb_delete";
				width = 8;
		    }
		    : button {
		        label = /*MSG4*/"추가";
		        key = "eb_add";
				width = 8;
		    }
	    }
	}
}

text_options : boxed_row {
    label = /*MSG5*/"문자유형";
    children_fixed_width = true;
    text_image;
	: column {
	    : popup_list {
	        label = /*MSG3*/"유형:";
	        key = "pop_textstyle";
	        edit_width = 16;
	    }
		: row {
		    children_fixed_width = true;
		    : edit_box {
		        label = /*MSG20*/"크기: ";
		     	key = "ed_textsize";
		        edit_width = 5;
		    }		    
	    }    	
	}
}

//-------------------- Main Dialogues --------------------
dd_rm : dialog {
    label = /*MSG46*/"실명작성";
    roomname_prop;
    room_options;
    text_options;
    ok_cancel;
}