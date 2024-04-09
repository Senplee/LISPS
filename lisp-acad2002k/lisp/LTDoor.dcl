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
        label = /*MSG20*/"��Ʋ ũ�� :";
        key = "tg_frame_size";
    }
    : edit_box_8 {
     	key = "ed_frame_size";
    }
}

offset_distance : row {
    : toggle {
        label = /*MSG20*/"���� ���� :";
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
        label = /*MSG5*/"�ǳ�";
        mnemonic = /*MSG6*/"P";
        key = "rd_panel";
    }
    : radio_button {
        label = /*MSG3*/"��Ʋ";
        mnemonic = /*MSG4*/"F";
        key = "rd_frame";
    }
    : radio_button {
        label = /*MSG5*/"����";
        mnemonic = /*MSG6*/"A";
        key = "rd_arc";
    }
    : radio_button {
        label = /*MSG5*/"����";
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
    label = /*MSG25*/"��Ʋ";
    key = "sill_type_radio";
    : radio_button {
        label = /*MSG25*/"���и���";
        key = "rd_sill_2";
    }
    : radio_button {
        label = /*MSG27*/"����";
        key = "rd_thres";
    }
    : radio_button {
        label = /*MSG29*/"����";
        key = "rd_none";
    }
}

door_prop : boxed_column {
    label = /*MSG2*/"Ư��";
    prop_type;
    //th_el_edit_box;
    door_prop_radio;
}

door_type : boxed_column {
    label = /*MSG2*/"��";
    door_image_button;
   	door_type_radio;
}

door_options : boxed_column {
    label = /*MSG15*/"�� ���";
	opening_size;
	: row {
		spacer;
	    : edit_box_8 {
	        label = /*MSG13*/"�ǳ� �β� :";
	        key = "ed_panel_thick";
	    }
	}
	: column {
        key = "other_size_panel";
		: row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG20*/"ù° �ǳ� :";
		     	key = "ed_1st_panel_size";
		    }
		}
		:row {
			spacer;
	        : text {
		        label = /*MSG32*/"�ι�° �ǳ� :";
	        }
	        : text {
		        key = "tx_2nd_panel_size";
	            width = 8;
	        }
		}
	}
}

frame_options : boxed_row {
    label = /*MSG15*/"��Ʋ���û���";
    children_fixed_width = true;
	: column {
	    : image_button_3 {
	        key = "ib_frame_type";
	    }
	    : button {
	        label = /*MSG16*/"����...";
	        key = "bn_frame_type";
	        width = 4.5;
			allow_accept = true;
	    }
    }
	: column {
		: row {
			spacer;
		    : edit_box_8 {
		        label = /*MSG18*/"��ƴ :";
		        key = "ed_gap_size";
		    }
	    }
	    frame_size;
		offset_distance;
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
dd_door : dialog {
    label = /*MSG46*/"�� �׸���";
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
    label = /*MSG14*/"���� ����";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	//	basic_type_item;
	    : text {
	        label = /*MSG17*/"Ÿ �� ��";
	        width = 7;
	    }
	     : text {
	        label = /*MSG17*/"�� Ÿ ��";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"��    ��";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"��������";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"�� �� ��";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"������Ÿ��";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"Sill Ÿ��";
	        width = 7;
	    }
	    : text {
	        label = /*MSG17*/"�� Ÿ��";
	        width = 7;
	    }
//    	    : text {
//	        label = /*MSG17*/"�����ӵβ�";
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
    label = /*MSG45*/"���� ����";
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
    label = /*MSG45*/"��Ʋ";
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
