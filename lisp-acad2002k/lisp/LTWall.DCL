/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   WALL97.DCL   Version 1.0
//
//   Copyright (C) 1995/6 by korea CIM, LTD.
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
// Corresponding dialogues for WALLDCL.CPP which is an AutoLISP implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------


@include "setprop.dcl"

wall_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"벽";
        key = "rd_wall";
    }
    : radio_button {
        label = /*MSG3*/"마감선";
        key = "rd_finish";
    }
//    : radio_button {
//        label = /*MSG5*/"단열재";
//        key = "rd_cavity";
//    }
}

wall_type_radio : radio_row {
	key = "wall_type_radio";
    : radio_button {
        label = /*MSG5*/"Single";
        key = "rd_single";
    }
    : radio_button {
        label = /*MSG5*/"Double";
        key = "rd_double";
    }
}

wall_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
   // th_el_edit_box;
    wall_prop_radio;
}

wall_image : image {
    key = "wall_image";
    height       = 5;
    aspect_ratio = 1.2;
    color        = 0;
}

wall_type_options : boxed_column {
    children_fixed_width = true;
    label = /*MSG2*/"벽체";
    wall_type_radio;
    : edit_box_8 {
        key = "ed_drag";
        label = /*MSG8*/"편심:";
    }
}

finish_options : boxed_column {
    label = /*MSG2*/"마감 두께";
    key = "finish_width";
    : edit_box_8 {
        key = "eb_finish_left";
        label = /*MSG8*/"왼쪽:";
    }
    : edit_box_8 {
        key = "eb_finish_right";
        label = /*MSG22*/"오른쪽:";
    }
}

wall_width_options : boxed_row {
    label = /*MSG2*/"벽체 두께";
    children_fixed_width = true;
	: column {
	    : edit_box_8 {
	        key = "eb_total_width";
	        label = /*MSG8*/"전체 두께:";
	    }
	    : edit_box_8 {
	        key = "eb_left_width";
	        label = /*MSG8*/"왼쪽 두께:";
	        allow_accept = true;
	    }
    }
	: column {
	    : edit_box_8 {
	        key = "eb_right_width";
	        label = /*MSG22*/"오른쪽 두께:";
	        allow_accept = true;
	    }
		: row {
		    : text_part {
	            label = /*MSG15*/"단열재 두께: ";
	        }
	        : text_part {
	            key = "tx_cave_width";
	            width = 8;
	        }
	    }
    }
}

caps_options : boxed_radio_row {
    label = /*MSG12*/"벽체 정리";
    key = "caps_radio";
    : radio_button {
        label = /*MSG13*/"자동";
        key = "rd_auto";
    }
    : radio_button {
        label = /*MSG15*/"양쪽";
        key = "rd_both";
    }
    : radio_button {
        label = /*MSG17*/"시작점";
        key = "rd_start";
    }
    : radio_button {
        label = /*MSG19*/"끝점";
        key = "rd_end";
    }
    : radio_button {
        label = /*MSG21*/"하지 않음";
        key = "rd_none";
    }
}

join_options : boxed_column{
    label = /*MSG2*/"맞물림 방식";
    : toggle {
        label = /*MSG26*/"자르기";
        key = "tg_break";
    }
    : toggle {
        label = /*MSG28*/"붙이기";
        key = "tg_attach";
    }
}

pickbox_options : boxed_row {
    label = /*MSG30*/"선택 상자 크기";
    children_fixed_width = true;
    : column {
        : text {
            label = /*MSG31*/"최소                                      최대";
            alignment = centered;
        }
        : slider {
            key = "pickbox_slider";
            min_value = 0;
            max_value = 19;
            width = 30;
            height = 1;
            small_increment = 1;
            big_increment = 1;
        }
    }
    : image {
        key = "pickbox_image";
        aspect_ratio = 1;
        height = 3;
        color = -2;
    }
}

//-------------------- Main Dialogues --------------------
dd_wall : dialog {
    label = /*MSG1*/"벽체 그리기";
    wall_prop;
	: row {
		wall_image;
		wall_type_options;
		finish_options;
	//	
	}
	
	wall_width_options;
	caps_options;
	:row{
	join_options;
	pickbox_options;
	}
    save_ok_cancel_help_errtile;
}

//-------------------- Sub Dialogues --------------------
set_type_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"벽체 유형 선택";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
		basic_type_item1;
    }
    : list_box {
        tabs = "9 18 27 36 48 58 69 80";
        width = 80;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_err;
}

basic_type_item1 : row {
    : text {
        label = /*MSG16*/"타입명";
        width = 8;
    }
    : text {
        label = /*MSG16*/"벽타입";
        width = 8;
    }
    : text {
        label = /*MSG18*/"벽두께";
        width = 8;
    }
    : text {
        label = /*MSG19*/"왼쪽두께";
        width = 8;
    }
    : text {
        label = /*MSG19*/"오른쪽두께";
        width = 8;
    }
    : text {
        label = /*MSG19*/"밖마감";
        width = 8;
    }
    : text {
        label = /*MSG19*/"안마감";
        width = 8;
    }
    : text {
        label = /*MSG19*/"Caps";
        width = 8;
    }
}
