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
        label = /*MSG5*/"유리";
        mnemonic = /*MSG6*/"G";
        key = "rd_glass";
    }
    : radio_button {
        label = /*MSG3*/"창틀";
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
        label = /*MSG3*/"단순표현";
        key = "rd_simple";
    }
    : radio_button {
        label = /*MSG5*/"상세 표현";
        key = "rd_detail";
    }
}

window_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
    //th_el_edit_box;
    window_prop_radio;
}

window_type : boxed_column {
    label = /*MSG2*/"창문 유형";
    window_image_button;
   	window_type_radio;
}

window_options : boxed_column {
    label = /*MSG15*/"선택 사항";
	opening_size;
	: row {
		spacer;
	    : edit_box_8 {
	        label = /*MSG13*/"문짝 개수:";
	        key = "ed_case_num";
	    }
	}
	: column {
        key = "sliding_size";
		: row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG20*/"첫째 창문 크기:";
		     	key = "ed_1st_sld_size";
		    }
		}
		:row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG20*/"둘째 창문 크기:";
		     	key = "ed_2nd_sld_size";
		    }
		}
	}
}

frame_options : boxed_column {
    label = /*MSG15*/"창틀 종류";
    : row {
	    children_fixed_width = true;
	    : radio_row {
			key = "frame_type_radio";
	        : radio_button {
	             label = /*MSG3*/"알루미늄";
	             key = "rd_alumin";
	        }
	        : radio_button {
	             label = /*MSG5*/"나무";
	             key = "rd_wood";
	         }
	        : radio_button {
	             label = /*MSG5*/"알루미늄+나무";
	             key = "rd_alwd";
	         }
	    }
 		offset_distance;
    }
    : row {
	    children_fixed_width = true;
       : toggle {
            label = /*MSG20*/"창문지방 그리기";
            key = "tg_stool";
        }
        : edit_box {
            key = "ed_gap_size";
            label = /*MSG32*/"창틀 틈:";
            edit_width = 8;
        }
        : edit_box {
            key = "ed_frame_size";
            label = /*MSG18*/"창틀굵기:";
            edit_width = 8;
        }
    }
}

wall_type_radio : boxed_radio_row {
    label = /*MSG31*/"마감 방법";
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
    label = /*MSG46*/"창문 평면 그리기";
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
    label = /*MSG14*/"창문 유형 선택";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	//	basic_type_item;
	    : text {
	        label = /*MSG17*/"타입명";
	        width = 9;
	    }
	    : text {
	        label = /*MSG17*/"창문타입";
	        width = 9;
	    }
	    : text {
	        label = /*MSG17*/"디테일";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"크기";
	        width = 7;
	    }
	     : text {
	        label = /*MSG17*/"창갯수";
	        width = 6;
	    }
	     : text {
	        label = /*MSG17*/"프레임";
	        width = 8;
	    }
	     : text {
	        label = /*MSG17*/"프레임크기";
	        width = 6;
	    }
	     : text {
	        label = /*MSG17*/"창문지방";
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
    label = /*MSG45*/"창문 유형 선택";
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