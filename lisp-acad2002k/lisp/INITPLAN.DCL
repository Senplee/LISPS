/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   INITPLAN.DCL   Version 1.0
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
// Corresponding dialogues for INITPLAN.ARX which is an ARX implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------


@include "setprop.dcl"

//-------- Subassemblies and prototypes shared across several dialogues -------
toggle_options : row {
    : toggle {
        label = /*MSG20*/"축열";
        key = "tg_balloon";
    }
    : toggle {
        label = /*MSG20*/"치수";
        key = "tg_dimension";
    }
    : toggle {
        label = /*MSG20*/"기둥";
        key = "tg_column";
    }
}

row_numbers : boxed_column {
    label = /*MSG2*/"X/Y 개수";
    key = "row_numbers";
    : edit_box {
        label = /*MSG20*/"축열 가로(X) 개수(|||):";
     	key = "ed_x_number";
    }
    : edit_box {
        label = /*MSG20*/"축열 세로(Y) 개수(---):";
     	key = "ed_y_number";
    }
    : button {
        label = /*MSG5*/"중심선 간격";
        key = "bn_distance";
    }
}

column_size : boxed_row {
    label = /*MSG2*/"기둥 크기";
    key = "column_size";
    children_fixed_width = true;
    : edit_box {
        label = /*MSG20*/"가로 크기:";
     	key = "ed_x_size";
    }
    : edit_box {
        label = /*MSG20*/"세로 크기:";
     	key = "ed_y_size";
    }
}

initplan_image : image {
    key = "initplan_image";
    height       = 12;
    aspect_ratio = 1;
    color        = 0;
}

balloon_image : image {
    key = "balloon_image";
    height       = 5;
    aspect_ratio = 1;
    color        = 0;
}

ipl_prop_radio : radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"중심선";
        key = "rd_center";
    }
    : radio_button {
        label = /*MSG3*/"축열";
        key = "rd_balloon";
    }
    : radio_button {
        label = /*MSG5*/"문자";
        key = "rd_text";
    }
    : radio_button {
        label = /*MSG5*/"치수";
        key = "rd_dimension";
    }
    : radio_button {
        label = /*MSG5*/"기둥";
        key = "rd_column";
    }
}

balloon_type_radio : radio_column {
	key = "balloon_type_radio";
	fixed_height=true;
    : radio_button {
        label = /*MSG3*/"숫자/알파벳";
        key = "rd_number";
    }
    : radio_button {
        label = /*MSG3*/"알파벳/숫자";
        key = "rd_alphabet";
    }
    : radio_button {
        label = /*MSG5*/"X축/Y축";
        key = "rd_xy";
    }
}

balloon_options : boxed_column {
    label = /*MSG2*/"풍선 종류와 크기";
   	key = "balloon_options";
	: row {
	    children_fixed_width = true;
	    balloon_image;
	    balloon_type_radio;
	}
    : edit_box {
        label = /*MSG20*/"지름 :";
     	key = "ed_diameter";
     	edit_width = 5;
     	fixed_width = true;
     	alignment = left;
    }
}

other_options : row {
    children_fixed_width = true;
	column_size;
	: boxed_column {
        label = /*MSG3*/"치수 모양";
	    : popup_list {
	        key = "pop_dimstyle";
	        edit_width = 10;
	    }
	}
}

initplan_prop : boxed_column {
    label = /*MSG2*/"특성";
    properties;
    ipl_prop_radio;
}

initplan_type : boxed_column {
    label = /*MSG2*/"미리보기";
    children_fixed_width = true;
    initplan_image;
    toggle_options;
}

//-------------------- Main Dialogues --------------------
dd_ipl : dialog {
    label = /*MSG46*/"평면 중심선 자동 생성";
    initplan_prop;
    : row {
        initplan_type;
		: column {
	    	row_numbers;
	    	balloon_options;
		}
    }
    other_options;
    ok_cancel;
    errtile;
}

//-------------------- Sub Dialogues --------------------
titles : row {
    : text {
        label = /*MSG17*/"번호";
        width = 4;
    }
    : text {
        label = /*MSG17*/"중심선 간격";
        width = 9;
    }
}

set_distance : dialog {
    subassembly = 0;
    label = /*MSG14*/"중심선 간격 설정";
	: row {
	    : boxed_column {
	        label = /*MSG17*/"가로열";
			titles;
		    : list_box {
		        tabs = "6";
		        width = 16;
		        height = 12;
		        key = "list_column";
			multiple_select = true;
		    }
	    }
	    : boxed_column {
	        label = /*MSG17*/"세로열";
			titles;
		    : list_box {
		        tabs = "6";
		        width = 16;
		        height = 12;
		        key = "list_row";
			multiple_select = true;
		    }
	    }
    }
	: boxed_row {
	    children_fixed_width = true;
	    : edit_box {
	        label = /*MSG20*/"간격:";
	     	key = "ed_distance";
		    edit_width = 12;
			allow_accept = true;
	    }
	    : button {
	        label = /*MSG5*/"저장";
	        key = "bn_save";
			width = 12;
	    }
    }
    ok_cancel;
    errtile;
}

//-------------------- Sub Dialogues --------------------
set_layer : dialog {
    subassembly = 0;
    label = /*MSG14*/"Select Layer";
    initial_focus = "listbox";
    current_layer_name;
    : row {
        fixed_width = true;
        key = "titles";
        children_fixed_width = true;
        : text {
            label = /*MSG16*/"Layer Name";
            width = 16;
        }
        : text {
            label = /*MSG17*/"State";
            width = 10;
        }
        : text {
            label = /*MSG18*/"Color";
            width = 9;
        }
        : text {
            label = /*MSG19*/"Linetype";
            width = 12;
        }
    }
    : list_box {
        tabs = "15 18 20 22 24 27 36";
        width = 50;
        height = 12;
        key = "list_lay";
        allow_accept = true;
    }
    : row {
	    : edit_box {
	        label = /*MSG20*/"Set Layer Name:";
	        mnemonic = /*MSG21*/"S";
	        key = "edit_lay";
	        allow_accept = true;
	    }
        //: button {
        //    label = /*MSG4*/"Rename";
        //    mnemonic = /*MSG5*/"R";
        //    key = "ren_lay";
        //    width = 12;
        //    fixed_width = true;
        //}
    }
    ok_cancel_err;
}
