/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   WINDOW97.DCL   Version 1.0
//
//   Copyright (C) 1993/2 by Korea CIM, LTD.
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
// Corresponding dialogues for WINDCL.CPP which is an AutoLISP implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------


@include "setprop.dcl"

//-------- Subassemblies and prototypes shared across several dialogues -------

window_image_button : image_button {
    key = "ib_win_type";
    height       = 5;
    aspect_ratio = 2;
    color        = 0;
	allow_accept = true;
}

window_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"����";
        mnemonic = /*MSG6*/"G";
        key = "rd_glass";
    }
    : radio_button {
        label = /*MSG3*/"âƲ";
        mnemonic = /*MSG4*/"F";
        key = "rd_frame";
    }
//    : radio_button {
//        label = /*MSG5*/"Case";
//        mnemonic = /*MSG6*/"C";
//        key = "rd_prop_case";
//    }
    : radio_button {
        label = /*MSG5*/"Misc";
        mnemonic = /*MSG6*/"M";
        key = "rd_misc";
    }
}

window_type_radio : radio_row {
	key = "win_type_radio";
    : radio_button {
        label = /*MSG3*/"�ܼ�ǥ��";
        key = "rd_simple";
    }
    : radio_button {
        label = /*MSG5*/"�� ǥ��";
        key = "rd_detail";
    }
}

window_prop : boxed_column {
    label = /*MSG2*/"Ư��";
    prop_type;
    //th_el_edit_box;
    window_prop_radio;
}

window_type : boxed_column {
    label = /*MSG2*/"â�� ����";
    window_image_button;
   	window_type_radio;
}

window_options : boxed_column {
    label = /*MSG15*/"���� ����";
	opening_size;
	: row {
		spacer;
	    : edit_box_8 {
	        label = /*MSG13*/"��¦ ����:";
	        key = "ed_case_num";
	    }
	}
	: column {
        key = "sliding_size";
		: row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG20*/"ù° â�� ũ��:";
		     	key = "ed_1st_sld_size";
		    }
		}
		:row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG20*/"��° â�� ũ��:";
		     	key = "ed_2nd_sld_size";
		    }
		}
	}
}

frame_options : boxed_column {
    label = /*MSG15*/"âƲ ����";
    : row {
	    children_fixed_width = true;
	    : radio_row {
			key = "frame_type_radio";
	        : radio_button {
	             label = /*MSG3*/"�˷�̴�";
	             key = "rd_alumin";
	        }
	        : radio_button {
	             label = /*MSG5*/"����";
	             key = "rd_wood";
	         }
	        : radio_button {
	             label = /*MSG5*/"�˷�̴�+����";
	             key = "rd_alwd";
	         }
	    }
 		offset_distance;
    }
    : row {
	    children_fixed_width = true;
       : toggle {
            label = /*MSG20*/"â������ �׸���";
            key = "tg_stool";
        }
        : edit_box {
            key = "ed_gap_size";
            label = /*MSG32*/"âƲ ƴ:";
            edit_width = 8;
        }
        : edit_box {
            key = "ed_frame_size";
            label = /*MSG18*/"âƲ����:";
            edit_width = 8;
        }
    }
}

wall_type_radio : boxed_radio_row {
    label = /*MSG31*/"���� ���";
    key = "wall_type_radio";
    : image_button_3 {
        key = "ib_wall_1";
    }
    : image_button_3 {
        key = "ib_wall_2";
    }
    : image_button_3 {
        key = "ib_wall_3";
    }
    : image_button_3 {
        key = "ib_wall_4";
    }
}

//-------------------- Main Dialogues --------------------
dd_window : dialog {
    label = /*MSG46*/"â�� ��� �׸���";
    window_prop;
    : row {
        window_type;
    	window_options;
    }
    frame_options;
    wall_type_radio;
    save_ok_cancel_help_errtile;
}

//-------------------- Sub Dialogues --------------------
set_type_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"â�� ���� ����";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	//	basic_type_item;
	    : text {
	        label = /*MSG17*/"Ÿ�Ը�";
	        width = 9;
	    }
	    : text {
	        label = /*MSG17*/"â��Ÿ��";
	        width = 9;
	    }
	    : text {
	        label = /*MSG17*/"������";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"ũ��";
	        width = 7;
	    }
	     : text {
	        label = /*MSG17*/"â����";
	        width = 6;
	    }
	     : text {
	        label = /*MSG17*/"������";
	        width = 8;
	    }
	     : text {
	        label = /*MSG17*/"������ũ��";
	        width = 6;
	    }
	     : text {
	        label = /*MSG17*/"â������";
	        width = 6;
	    }
	   
    }
    : list_box {
        tabs = "10 20 30 38 46 59 72 78";
        width = 80;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_err;
}

set_window_type : dialog {
    label = /*MSG45*/"â�� ���� ����";
    : row {
        : radio_column {
			key = "win_type_radio_1";
            : image_button_4 {
                key = "ib_win_a";
            }
            : image_button_4 {
                key = "ib_win_b";
            }
            : image_button_4 {
                key = "ib_win_c";
            }
        }
        : radio_column {
			key = "win_type_radio_2";
            : image_button_4 {
                key = "ib_win_d";
            }
            : image_button_4 {
                key = "ib_win_e";
            }
            : image_button_4 {
                key = "ib_win_f";
            }
        }
    }
    ok_cancel_err;
}
offset_distance : row {
    : toggle {
        label = /*MSG20*/"Offset_Dist:";
        key = "tg_offset";
    }
    : edit_box_8 {
     	key = "ed_offset";
    }
}