/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   DWGTITLE.DCL   Version 1.0
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
// Corresponding dialogues for DWGTITLE.ARX which is an ARX implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------


@include "setprop.dcl"

//-------- Subassemblies and prototypes shared across several dialogues -------
dwgtitle_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_c_la;
    dtl_prop_radio;
}

dwgtitle_image : image_button {
    key = "bn_dtl_image";
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

dtl_prop_radio : radio_row {
    key = "prop_radio";
    : radio_button {
        label = /*MSG3*/"원";
        key = "rd_circle";
    }
    : radio_button {
        label = /*MSG3*/"일련번호";
        key = "rd_number";
    }
    : radio_button {
        label = /*MSG3*/"도면번호";
        key = "rd_dwgno";
    }
    : radio_button {
        label = /*MSG3*/"도면명";
        key = "rd_title";
    }
    : radio_button {
        label = /*MSG5*/"축적";
        key = "rd_scale";
    }
}

text_style_radio : radio_row {
    key = "style_radio";
    alignment = centered;
    : radio_button {
        label = /*MSG3*/"일련번호";
        key = "rd_st_number";
    }
    : radio_button {
        label = /*MSG3*/"도면번호";
        key = "rd_st_dwgno";
    }
    : radio_button {
        label = /*MSG3*/"도면명";
        key = "rd_st_title";
    }
    : radio_button {
        label = /*MSG5*/"축적";
        key = "rd_st_scale";
    }
}

dtl_options : row {
    children_fixed_width = true;
	: boxed_column {
	    label = /*MSG5*/"심볼 선택";
	    dwgtitle_image;
	    : edit_box {
	        label = /*MSG20*/"원의 지름:";
	     	key = "ed_diameter";
	        edit_width = 9;
	    }
	    : edit_box {
	        label = /*MSG20*/"일련번호:";
	     	key = "ed_number";
	        edit_width = 9;
	    }
		: row {
	     	key = "dwg_number";
		    : edit_box {
		        label = /*MSG20*/"도면번호:";
		     	key = "ed_dwgtype";
		        edit_width = 3;
		    }
		    : edit_box {
		     	key = "ed_dwgno";
		        edit_width = 3;
		    }
	    }
	}
	: boxed_column {
	    : edit_box {
	     	key = "ed_text";
	        edit_width = 24;
	    }
	    label = /*MSG5*/"도면명";
	    : list_box {
	        key = "list_text";
	        height = 8;
	    }
		: row {
		    : button {
		        label = /*MSG4*/"삭제";
		        key = "eb_delete";
				width = 12;
		    }
		    : button {
		        label = /*MSG4*/"추가";
		        key = "eb_add";
				width = 12;
		    }
	    }
	}
}

text_options : boxed_column {
    label = /*MSG5*/"문자유형";
    children_fixed_width = true;
        : row {
             text_image;
	     : column {
		    children_fixed_width = true;
	            : popup_list {
	                  label = /*MSG3*/"문자유형:";
	                  key = "pop_textstyle";
	                  edit_width = 20;
	             }
		    : edit_box {
		        label = /*MSG20*/"문자높이:";
		     	key = "ed_textsize";
		        edit_width = 5;
	            }
	            spacer_1;
	     }
	}     
    	text_style_radio;
}

//-------------------- Main Dialogues --------------------
dd_dtl : dialog {
    label = /*MSG46*/"도면제목 작성";
    dwgtitle_prop;
    dtl_options;
    text_options;
    ok_cancel_err;
}
