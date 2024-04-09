/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   DOOR97.DCL   Version 1.0
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
// Corresponding dialogues for DOORDCL.CPP which is an ARX implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------


@include "setprop.dcl"

//-------- Subassemblies and prototypes shared across several dialogues -------
frame_size : row {
   	key = "frame_size";
    : toggle {
        label = /*MSG20*/"문틀 크기 :";
        key = "tg_frame_size";
    }
    : edit_box_8 {
     	key = "ed_frame_size";
    }
}

offset_distance : row {
    : toggle {
        label = /*MSG20*/"시작 간격 :";
        key = "tg_offset";
    }
    : edit_box_8 {
     	key = "ed_offset";
    }
}

door_image_button : image_button {
    key = "door_type";
    alignment = centered;
   // height  = 3;
   // width =2;
   // aspect_ratio = 1;
    fixed_width = true;
    height = 4;
    aspect_ratio = 2;   
    color        = 0;
	allow_accept = true;
}

door_prop_radio : boxed_radio_row {
	
	key = "prop_radio";

    : radio_button {
        label = /*MSG5*/"판넬";
        mnemonic = /*MSG6*/"P";
        key = "rd_panel";
    }
    : radio_button {
        label = /*MSG3*/"문틀";
        mnemonic = /*MSG4*/"F";
        key = "rd_frame";
    }
    : radio_button {
        label = /*MSG5*/"스윙";
        mnemonic = /*MSG6*/"A";
        key = "rd_arc";
    }
    : radio_button {
        label = /*MSG5*/"문턱";
        mnemonic = /*MSG6*/"S";
        key = "rd_sill";
    }
}

door_type_radio : radio_row {
	key = "door_type_radio";
    : radio_button {
        label = /*MSG3*/"Simple";
        key = "simple";
    }
    : radio_button {
        label = /*MSG5*/"Detail";
        key = "detail";
    }
}

sill_type_radio : boxed_radio_column {
    label = /*MSG25*/"문틀";
    key = "sill_type_radio";
    : radio_button {
        label = /*MSG25*/"재료분리대";
        key = "rd_sill_2";
    }
    : radio_button {
        label = /*MSG27*/"문턱";
        key = "rd_thres";
    }
    : radio_button {
        label = /*MSG29*/"없음";
        key = "rd_none";
    }
}

door_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
    //th_el_edit_box;
    door_prop_radio;
}

door_type : boxed_column {
    label = /*MSG2*/"문";
    door_image_button;
   	door_type_radio;
}

door_options : boxed_column {
    label = /*MSG15*/"문 사양";
	opening_size;
	: row {
		spacer;
	    : edit_box_8 {
	        label = /*MSG13*/"판넬 두께 :";
	        key = "ed_panel_thick";
	    }
	}
	: column {
        key = "other_size_panel";
		: row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG20*/"첫째 판넬 :";
		     	key = "ed_1st_panel_size";
		    }
		}
		:row {
			spacer;
	        : text {
		        label = /*MSG32*/"두번째 판넬 :";
	        }
	        : text {
		        key = "tx_2nd_panel_size";
	            width = 8;
	        }
		}
	}
}

frame_options : boxed_row {
    label = /*MSG15*/"문틀선택사항";
    children_fixed_width = true;
	: column {
	    : image_button_3 {
	        key = "ib_frame_type";
	    }
	    : button {
	        label = /*MSG16*/"형태...";
	        key = "bn_frame_type";
	        width = 4.5;
			allow_accept = true;
	    }
    }
	: column {
		: row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG18*/"문틈 :";
		        key = "ed_gap_size";
		    }
	    }
	    frame_size;
		offset_distance;
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
dd_door : dialog {
    label = /*MSG46*/"문 그리기";
    door_prop;
    : row {
        door_type;
    	door_options;
    }
    : row {
        frame_options;
    	sill_type_radio;
    }
    wall_type_radio;
	save_ok_cancel_help_errtile;
    
}

//-------------------- Sub Dialogues --------------------
set_type_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"종류 선택";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	//	basic_type_item;
	    : text {
	        label = /*MSG17*/"타 입 명";
	        width = 7;
	    }
	     : text {
	        label = /*MSG17*/"문 타 입";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"문    폭";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"열림각도";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"문 두 께";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"프레임타입";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"Sill 타입";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"벽 타입";
	        width = 7;
	    }
//    	    : text {
//	        label = /*MSG17*/"프레임두께";
//	        width = 7;
//	    }

    }
    : list_box {
        tabs = "9 18 27 36 48 58 69 80"; ///"10 20 30 41 49 59";
        width = 72;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_err;  //_help_errtile;
}

set_door_type : dialog {
    label = /*MSG45*/"문의 종류";
    : row {
        : radio_column {
			key = "door_type_radio_1";
            : image_button_4 {
                key = "ib_door_A";
            }
            : image_button_4 {
                key = "ib_door_B";
            }
            : image_button_4 {
                key = "ib_door_C";
            }
            : image_button_4 {
                key = "ib_door_D";
            }
        }
        : radio_column {
			key = "door_type_radio_2";
            : image_button_4 {
                key = "ib_door_E";
            }
            : image_button_4 {
                key = "ib_door_F";
            }
            : image_button_4 {
                key = "ib_door_G";
            }
            : image_button_4 {
                key = "ib_door_H";
            }
        }
    }
   ok_cancel_err;
}

set_frame_type : dialog {
    label = /*MSG45*/"문틀";
    : column {
        : radio_row {
			key = "frame_type_radio_1";
            : image_button_3 {
                key = "ib_frame_a";
            }
            : image_button_3 {
                key = "ib_frame_b";
            }
            : image_button_3 {
                key = "ib_frame_c";
            }
        }
        : radio_row {
			key = "frame_type_radio_2";
            : image_button_3 {
                key = "ib_frame_d";
            }
            : image_button_3 {
                key = "ib_frame_e";
            }
            : image_button_3 {
                key = "ib_frame_f";
            }
        }
    }
    ok_cancel_err; //_help_errtile;
}
