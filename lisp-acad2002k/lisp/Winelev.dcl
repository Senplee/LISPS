/* Next available MSG number is  41 */
//=============================================================================
//Dialog box for Windows Elevation
//ArchiLogic Lab
//=============================================================================

@include "setprop.dcl"

//-------- Subassemblies and prototypes shared across several dialogues -------
number_box_8 : edit_box {
    edit_width = 8;
}

handle_type_button: image_button {
    fixed_width = true;
    height = 4;
    aspect_ratio = 1.2;
    color = 0;
    allow_accept = true;
}

elev_image : image {
    key = "elev_image";
    height       = 8;
    aspect_ratio = 1.5;
    color        = 0;
}

gap_size : row {
    : toggle {
        label = /*MSG20*/"창문틈:";
        key = "tg_gap_size";
    }
    : number_box_8 {
     	key = "ed_gap_size";
    }
}

transom_height : row {
    : toggle {
        label = /*MSG20*/"Trm_Hght:";
        key = "tg_hght_2";
    }
    : number_box_8 {
     	key = "ed_hght_2";
    }
}

opening_width : row {
    : toggle {
        label = /*MSG20*/"가로크기:";
        key = "tg_opn_width";
    }
    : number_box_8 {
     	key = "ed_opn_width";
    }
}

opening_height : row {
    : toggle {
        label = /*MSG20*/"세로크기:";
        key = "tg_opn_height";
    }
    : number_box_8 {
    	key = "ed_opn_height";
    }
}

f_m_t_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG3*/"창틀";
        mnemonic = /*MSG4*/"F";
        key = "rd_frame";
    }
    : radio_button {
        label = /*MSG5*/"가로틀";
        mnemonic = /*MSG6*/"M";
        key = "rd_mullion";
    }
    : radio_button {
        label = /*MSG5*/"세로틀";
        mnemonic = /*MSG6*/"T";
        key = "rd_transom";
    }
    : radio_button {
        label = /*MSG5*/"Open_Line";
        mnemonic = /*MSG6*/"L";
        key = "rd_openline";
    }
}

f_c_m_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG3*/"창틀";
        mnemonic = /*MSG4*/"F";
        key = "rd_frame";
    }
    : radio_button {
        label = /*MSG5*/"미들창";
        mnemonic = /*MSG6*/"C";
        key = "rd_casement";
    }
    : radio_button {
        label = /*MSG5*/"열림표시";
        mnemonic = /*MSG6*/"M";
        key = "rd_open_mark";
    }
    : radio_button {
        label = /*MSG5*/"Outline";
        mnemonic = /*MSG6*/"O";
        key = "rd_outline";
    }
}

f_h_m_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG3*/"창틀";
        mnemonic = /*MSG4*/"F";
        key = "rd_frame";
    }
    : radio_button {
        label = /*MSG5*/"손잡이";
        mnemonic = /*MSG6*/"H";
        key = "rd_casement";
    }
    : radio_button {
        label = /*MSG5*/"열림표시";
        mnemonic = /*MSG6*/"M";
        key = "rd_open_mark";
    }
    : radio_button {
        label = /*MSG5*/"Outline";
        mnemonic = /*MSG6*/"O";
        key = "rd_outline";
    }
}

v_h_f_type_radio : radio_row {
	key = "w_radio";
    : radio_button {
        label = /*MSG3*/"수직";
        mnemonic = /*MSG4*/"V";
        key = "vertical";
    }
    : radio_button {
        label = /*MSG5*/"수평";
        mnemonic = /*MSG6*/"H";
        key = "horizon";
    }
    : radio_button {
        label = /*MSG5*/"편평";
        mnemonic = /*MSG6*/"F";
        key = "flat";
    }
}

a_b_type_radio : radio_row {
	key = "w_radio";
    : radio_button {
        label = /*MSG3*/"A 유형";
        mnemonic = /*MSG4*/"A";
        key = "a_type";
    }
    : radio_button {
        label = /*MSG5*/"B 유형";
        mnemonic = /*MSG6*/"B";
        key = "b_type";
    }
}

l_r_a_type_radio : radio_row {
	key = "s_radio";
    : radio_button {
        label = /*MSG3*/"좌측";
        mnemonic = /*MSG4*/"L";
        key = "left";
    }
    : radio_button {
        label = /*MSG5*/"우측";
        mnemonic = /*MSG6*/"R";
        key = "right";
    }
    : radio_button {
        label = /*MSG5*/"양측";
        mnemonic = /*MSG6*/"l";
        key = "all";
    }
}

panel_type_radio : radio_row {
	key = "p_radio";
    : radio_button {
        label = /*MSG3*/"1panl";
        key = "1panel";
    }
    : radio_button {
        label = /*MSG5*/"2panl";
        key = "2panel";
    }
    : radio_button {
        label = /*MSG5*/"None";
        key = "none";
    }
}

door_type_radio : radio_row {
	key = "d_radio";
    : radio_button {
        label = /*MSG3*/"Auto  ";
        key = "auto";
    }
    : radio_button {
        label = /*MSG5*/"Push ";
        key = "push";
    }
    : radio_button {
        label = /*MSG5*/"Revl";
        key = "revolv";
    }
}

f_m_t_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
    f_m_t_prop_radio;
}

f_c_m_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
    f_c_m_prop_radio;
}

f_h_m_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
    f_h_m_prop_radio;
}

cwin_type : boxed_column {
    label = /*MSG2*/"창문 유형";
    elev_image;
    v_h_f_type_radio;
}

swin_type : boxed_column {
    label = /*MSG2*/"창문 유형";
    elev_image;
	: row {
	    a_b_type_radio;
	    : toggle {
	        label = /*MSG20*/"열림표시";
	        key = "opn_mark";
	    }
    }
}

sfwin_type : boxed_column {
    label = /*MSG2*/"창문 유형";
    elev_image;
	: row {
	    a_b_type_radio;
	    : toggle {
	        label = /*MSG20*/"열림표시";
	        key = "opn_mark";
	    }
    }
    l_r_a_type_radio;
}

gwin_type : boxed_column {
    label = /*MSG2*/"창문 유형";
    elev_image;
	: row {
	    a_b_type_radio;
	    : toggle {
	        label = /*MSG20*/"열림표시";
	        key = "opn_mark";
	    }
    }
    panel_type_radio;
    door_type_radio;
}

cwin_frame_options : boxed_column {
    label = /*MSG15*/"창틀 선택사항";
    gap_size;
    : number_box_8 {
        key = "f_size";
        label = /*MSG18*/"창틀 두께:";
    }
    : number_box_8 {
        key = "size_2";
        label = /*MSG18*/"세로틀 크기:";
    }
    : number_box_8 {
        key = "size_1";
        label = /*MSG18*/"가로틀 크기:";
    }
}

swin_frame_options : boxed_column {
    label = /*MSG15*/"창틀 선택사항";
    gap_size;
    : number_box_8 {
        key = "f_size";
        label = /*MSG18*/"창틀 두께:";
    }
    : number_box_8 {
        key = "c_size";
        label = /*MSG18*/"창문틀 두께:";
    }
    : number_box_8 {
        key = "num_1";
        label = /*MSG18*/"창 개수:";
    }
}

sfwin_frame_options : boxed_column {
    label = /*MSG15*/"창틀 선택사항";
    gap_size;
	:row {
		spacer;
	    : number_box_8 {
	        key = "f_size";
	        label = /*MSG18*/"창틀 두께:";
	    }
	}
	:row {
		spacer;
	    : number_box_8 {
	        key = "c_size";
	        label = /*MSG18*/"창문틀 두께:";
	    }
    }
}

pwin_frame_options : boxed_column {
    label = /*MSG15*/"창틀 선택사항";
    gap_size;
    : number_box_8 {
        key = "f_size";
        label = /*MSG18*/"창틀 크기:";
    }
    : number_box_8 {
        key = "num_1";
        label = /*MSG32*/"고정창 개수:";
    }
    : number_box_8 {
        key = "num_2";
        label = /*MSG18*/"미들창 개수:";
    }
    : number_box_8 {
        key = "hght_2";
        label = /*MSG18*/"미들창 높이:";
    }
}

fswin_frame_options : boxed_column {
    label = /*MSG15*/"창틀 선택사항";
    gap_size;
    : number_box_8 {
        key = "f_size";
        label = /*MSG18*/"창틀 두께:";
    }
    : number_box_8 {
        key = "c_size";
        label = /*MSG18*/"고정창  두께:";
    }
    : number_box_8 {
        key = "num_1";
        label = /*MSG32*/"미서기창 개수:";
    }
    : number_box_8 {
        key = "hght_2";
        label = /*MSG18*/"미서기창 높이:";
    }
}

gwin_frame_options : boxed_column {
    label = /*MSG15*/"창틀 선택사항";
    gap_size;
    : number_box_8 {
        key = "f_size";
        label = /*MSG18*/"Frame_Size:";
    }
    : number_box_8 {
        key = "num_1";
        label = /*MSG32*/"Case_Num:";
    }
	transom_height;
}

gwin_door_options : boxed_column {
    label = /*MSG15*/"Door_Options";
    key = "d_option";
    : number_box_8 {
        key = "size_1";
        label = /*MSG18*/"Door_Width:";
    }
    : number_box_8 {
        key = "num_2";
        label = /*MSG18*/"Door_Locat:";
    }
}

sfwin_sliding_options : boxed_column {
    label = /*MSG15*/"미서기 선택사항";
	:row {
		spacer;
	    : number_box_8 {
	        key = "size_1";
	        label = /*MSG32*/"좌측 크기:";
	    }
    }
	:row {
		spacer;
	    : number_box_8 {
	        key = "size_2";
	        label = /*MSG18*/"우측 크기:";
	    }
    }
	:row {
		spacer;
	    : text_part {
	        label = /*MSG18*/" 고정창 크기:";
		}
	    : text_part {
	        key = "fix_size";
	        width = 8;
		}
	}
}

cwin_opening_options : boxed_row {
    label = /*MSG15*/"창문 선택사항";
    children_fixed_width = true;
    : column {
	    opening_width;
		:row {
			spacer_0;
		    : number_box_8 {
		        key = "num_1";
		        label = /*MSG13*/"가로 개수:";
		    }
		}
	}
    : column {
	    opening_height;
		:row {
			spacer_0;
		    : number_box_8 {
		        key = "num_2";
		        label = /*MSG13*/"세로 개수:";
		    }
		}
	}
}

gwin_other_options : boxed_row {
    label = /*MSG15*/"Other_Options";
    children_fixed_width = true;
    : button {
        fixed_width = true;
        label = /*MSG16*/"Handle_Type...";
        key = "b_handle";
        width = 16;
    }
    : number_box_8 {
        key = "size_2";
        label = /*MSG18*/"Finish_Thick:";
    }
}

swin_opening_options : boxed_row {
    label = /*MSG15*/"창문 선택사항";
    children_fixed_width = true;
    : column {
	    opening_width;
	}
    : column {
	    opening_height;
	}
}

//-------------------- Main Dialogues --------------------
dd_cwin : dialog {
    label = /*MSG46*/"커튼월 입면 그리기";
    f_m_t_prop;
    : row {
        cwin_type;
	    cwin_frame_options;
    }
    cwin_opening_options;
    save_ok_cancel_help_errtile;
}

dd_swin : dialog {
    label = /*MSG46*/"미서기 창 입면 그리기";
    f_c_m_prop;
    : row {
        swin_type;
	    swin_frame_options;
    }
    swin_opening_options;
    save_ok_cancel_help_errtile;
}

dd_sfwin : dialog {
    label = /*MSG46*/"미서기+고정창 입면 그리기";
    f_c_m_prop;
    : row {
        sfwin_type;
		: column {
	    	sfwin_frame_options;
	    	sfwin_sliding_options;
		}
    }
    swin_opening_options;
    save_ok_cancel_help_errtile;
}

dd_pwin : dialog {
    label = /*MSG46*/"미들창 + 고정창 입면 그리기";
    f_c_m_prop;
    : row {
        swin_type;
    	pwin_frame_options;
    }
    swin_opening_options;
    save_ok_cancel_help_errtile;
}

dd_fswin : dialog {
    label = /*MSG46*/"미서기+고정창 입면 그리기";
    f_c_m_prop;
    : row {
        swin_type;
    	fswin_frame_options;
    }
    swin_opening_options;
    save_ok_cancel_help_errtile;
}

dd_gwin : dialog {
    label = /*MSG46*/"Fix_Window_Glass_Door_Elevation";
    f_h_m_prop;
    : row {
        gwin_type;
		: column {
	    	gwin_frame_options;
	    	gwin_door_options;
		}
    }
    gwin_other_options;
    swin_opening_options;
    save_ok_cancel_help_errtile;
}

//-------------------- Sub Dialogues --------------------
set_cwintype_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"Select Window Elevation Type";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
       
	: text {
	        label = /*MSG17*/"타입명";
	        width = 8;
	    }
	  : text {
	        label = /*MSG17*/"커튼월타입";
	        width = 8;
	    }
	   
	   : text {
	        label = /*MSG17*/"창 너비";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 높이";
	        width = 8;
	    }
	   : text {
            label = /*MSG17*/"Num_X";
            width = 6;
            }
           : text {
            label = /*MSG17*/"Num_Y";
            width = 6;
            }
       : text {
	        label = /*MSG17*/"mullion_size";
	        width = 8;
	    } 
	    
	 
        : text {
            label = /*MSG17*/"transom_size";
            width = 8;
        }
        
    }
    : list_box {
        tabs = "10 22 30 40 50 60 70 80";
        width = 77;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_help_errtile;
}

set_swintype_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"Select Window Elevation Type";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
		basic_type_item;
	    : text {
	        label = /*MSG17*/"Opn_Width";
	        width = 9;
	    }
	    : text {
	        label = /*MSG17*/"Opn_Height";
	        width = 9;
	    }
        : text {
            label = /*MSG17*/"Case_Num";
            width = 6;
        }
    }
    : list_box {
        tabs = "10 20 30 40 50 60";
        width = 72;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_help_errtile;
}

set_sfwintype_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"Select Window Elevation Type";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	//	basic_type_item;
	 : text {
	        label = /*MSG17*/"타입명";
	        width = 8;
	    }
	  : text {
	        label = /*MSG17*/"창문타입";
	        width = 8;
	    }
	    : text {
	        label = /*MSG17*/"미서기창위치";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 너비";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 높이";
	        width = 8;
	    }

	    : text {
	        label = /*MSG17*/"왼쪽창크기";
	        width = 8;
	    } 
	    
	 
        : text {
            label = /*MSG17*/"오른창크기";
            width = 8;
        }
        : text {
            label = /*MSG17*/"프레임크기";
            width = 8;
        }
    }
    : list_box {
        tabs = "10 22 33 42 53 65 79 89";
        width = 86;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_help_errtile;
}

set_pwintype_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"Select Window Elevation Type";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	//	basic_type_item;
 	  : text {
	        label = /*MSG17*/"타입명";
	        width = 8;
	    }
	  : text {
	        label = /*MSG17*/"창문타입";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 너비";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 높이";
	        width = 8;
	    }

	    : text {
	        label = /*MSG17*/"Frame_SIZE";
	        width = 8;
	    } 
	    : text {
	        label = /*MSG17*/"고정창개수";
	        width = 8;
	    }
	 
        : text {
            label = /*MSG17*/"미들창개수";
            width = 8;
        }
        : text {
            label = /*MSG17*/"미들창높이";
            width = 8;
        }
    }
    : list_box {
        tabs = "10 20 30 40 50 60 70";
        width = 80;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_help_errtile;
}

set_fswintype_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"Select Window Elevation Type";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	 : text {
	        label = /*MSG17*/"타입명";
	        width = 8;
	    }
	 
	   : text {
	        label = /*MSG17*/"창 너비";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 높이";
	        width = 8;
	    }
	     : text {
	        label = /*MSG17*/"창틀크기";
	        width = 8;
	    }
	    : text {
	        label = /*MSG17*/"고정창창틀";
	        width = 8;
	    } 
	    : text {
	        label = /*MSG17*/"고정창갯수";
	        width = 8;
	    }
	 
        : text {
            label = /*MSG17*/"미서기창높이";
            width = 8;
        }
        : text {
            label = /*MSG17*/"Gap_SIZE";
            width = 8;
        }
    }
    : list_box {
        tabs = "9 18 28 40 52 63 77 90";
        width = 82;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_help_errtile;
}

set_gwintype_name : dialog {
    subassembly = 0;
    label = /*MSG14*/"Select Window Elevation Type";
    initial_focus = "listbox";
    current_type_name;
    : row {
        key = "titles";
	//	basic_type_item;

	 : text {
	        label = /*MSG17*/"타입명";
	        width = 8;
	    }
	  : text {
	        label = /*MSG17*/"창문타입";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 너비";
	        width = 8;
	    }
	   : text {
	        label = /*MSG17*/"창 높이";
	        width = 8;
	    }
	    : text {
	        label = /*MSG17*/"갭사이즈";
	        width = 8;
	    } 
	    : text {
	        label = /*MSG17*/"프레임사이즈";
	        width = 8;
	    }
	 
        : text {
            label = /*MSG17*/"Case_SIZE";
            width = 8;
        }
        : text {
            label = /*MSG17*/"Case_Num";
            width = 8;
        }
    }
    : list_box {
        tabs = "10 20 30 40 49 59 64";
        width = 77;
        height = 12;
        key = "list_type";
        allow_accept = true;
    }
    type_edit_field;
    ok_cancel_help_errtile;
}

set_handle : dialog {
    label = /*MSG45*/"Select_Door_Handle_Type";
    : radio_row {
		key = "handle_type_radio_1";
        : handle_type_button {
            key = "ib_handle_a";
        }
        : handle_type_button {
            key = "ib_handle_b";
        }
        : handle_type_button {
            key = "ib_handle_c";
        }
        : handle_type_button {
            key = "ib_handle_d";
        }
    }
    : radio_row {
		key = "handle_type_radio_2";
        : handle_type_button {
            key = "ib_handle_e";
        }
        : handle_type_button {
            key = "ib_handle_f";
        }
        : handle_type_button {
            key = "ib_handle_g";
        }
        : handle_type_button {
            key = "ib_handle_h";
        }
    }
    ok_cancel_help_errtile;
}
