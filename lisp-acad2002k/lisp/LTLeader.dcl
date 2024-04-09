/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   LEADER.DCL   Version 1.0
//
//   Copyright (C) 1996/8 by Korea CIM, LTD.
//----------------------------------------------------------------------------

@include "setprop.dcl"

//-------- Subassemblies and prototypes shared across several dialogues -------
leader_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_c_la;
    prop_radio;
}

leader_image : image_button {
    key = "bn_leader_image";
    height       = 6;
    aspect_ratio = 1.5;
    color        = 0;
    
}

arrow_image : image_button {
    key = "bn_arrow_image";
    height =2;
    aspect_ratio = 2;
    color        = 0;
}

text_image : image {
    key = "text_image";
    height       = 6;
    aspect_ratio = 1.5;
    color        = -2;
}

prop_radio : radio_row {
    key = "prop_radio";
    : radio_button {
        label = /*MSG3*/"지시선";
        key = "rd_leader";
    }
    : radio_button {
        label = /*MSG3*/"재료표기";
        key = "rd_text";
    }
}

text_radio : radio_row {
    key = "text_radio";
    : radio_button {
        label = /*MSG3*/"켜기";
        key = "rd_text_on";
    }
    : radio_button {
        label = /*MSG3*/"끄기";
        key = "rd_text_off";
    }
}

leader_options : row {
    children_fixed_width = true;
	: boxed_column {
	    label = /*MSG5*/"지시선";
	    leader_image;
		: row {
		    children_fixed_width = true;
		    arrow_image;
			: row {
				spacer_0;
			    : text {
			        label = /*MSG20*/"촉 크기:";
			    }
			    : edit_box {
			     	key = "ed_size";
			        edit_width = 5;
			    }
				spacer_0;
		    }
	    }
		: row {
		    children_fixed_width = true;
		    : text {
		        label = /*MSG20*/"재료표기:";
		    }
		    text_radio;
	    }
	}
	: boxed_column {
	    label = /*MSG5*/"마감재료";
	    : edit_box {
	     	key = "ed_text";
	        edit_limit = 1023;
	    }
	    : list_box {
	        key = "list_text";
	        height = 8;
	    }
		: row {
		    : button {
		        label = /*MSG4*/"초기화";
		        key = "eb_clear";
		    }
		    : button {
		        label = /*MSG4*/"삭제";
		        key = "eb_delete";
		    }
		    : button {
		        label = /*MSG4*/"추가";
		        key = "eb_add";
		    }
	    }
	}
}

text_options : boxed_row {
    label = /*MSG5*/"재료표기";
	key = "text_options";
    children_fixed_width = true;
    text_image;
	: column {
	    : popup_list {
	        label = /*MSG3*/"글꼴:";
	        key = "pop_textstyle";
	        edit_width = 16;
	    }
	    : edit_box {
	        label = /*MSG20*/"크기: ";
	     	key = "ed_textsize";
	        edit_width = 16;
	    }
	    spacer_1;
	}
}

//-------------------- Main Dialogues --------------------
dd_leader : dialog {
    label = /*MSG46*/"마감 재료 표기";
    leader_prop;
    leader_options;
    text_options;
    ok_cancel_err; //_help_errtile;
}
