/* Next available MSG number is  26 */

/*  SETPROP.DCL        Version 1.0

    Copyright (C) 1995 by Korea CIM, LTD.

    Permission to use, copy, modify, and distribute this software
    for any purpose and without fee is hereby granted, provided
    that the above copyright notice appears in all copies and that
    both that copyright notice and this permission notice appear in
    all supporting documentation.

    THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED
    WARRANTY.  ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR
    PURPOSE AND OF MERCHANTABILITY ARE HEREBY DISCLAIMED.

    Dialogue for the Setting Property command, for use with *.exe
*/


dcl_settings : default_dcl_settings { audit_level = 0; }

//-------- Subassemblies and prototypes shared across several dialogues -------

save_ok_cancel_help_errtile : row {
	: column {
	    children_fixed_width = true;
		: button {
            label = /*MSG4*/"유형 저장";
            key = "bn_type_save";
        }
		spacer_0;
    }
    ok_cancel_err;
}

textbox : edit_box {
    vertical_margin = tiny;
    horizontal_margin = tiny;
}    

edit_box_8 : edit_box {
    edit_width = 8;
	allow_accept = true;
}

image_button_3 : image_button {
    fixed_width = true;
    height = 3;
    aspect_ratio = 1.5;
    color = 0;
	allow_accept = true;
}

image_button_4 : image_button {
    fixed_width = true;
    height = 4;
    aspect_ratio = 2;
    color = 0;
	allow_accept = true;
}

opening_size : row {
    : toggle {
        label = /*MSG20*/"크기 :";
        key = "tg_opn_size";
    }
    : edit_box_8 {
     	key = "ed_opn_size";
    }
}

prop_type : column {
    children_fixed_width = true;
    :row {
        : column {
            fixed_width = true;
            : row {
                : button {
                    label = /*MSG2*/"색...";
                    mnemonic = /*MSG3*/"C";
                    key = "b_color";
                }
                : image_button {
                    key = "color_image";
                    height = 1;
                    width = 3;
                }
            }
            : button {
                label = /*MSG6*/"선...";
                mnemonic = /*MSG7*/"i";
                key = "b_line";
            }
            : button {
                label = /*MSG4*/"도면층...";
                mnemonic = /*MSG5*/"L";
                key = "b_name";
            }
        }
        : column {
            spacer_0;
            : text {
                key = "t_color";
                width = 18;
            }
            : text {
                key = "t_ltype";
                width = 18;
            }
            : text {
                key = "t_layer";
                width = 18;
            }
            spacer_0;
        }
        : column {
		    children_fixed_height = true;
            spacer_0;
            : toggle {
                label = /*MSG24*/" bylayer ";
                key = "c_bylayer";
            }
            : toggle {
                label = /*MSG25*/" bylayer ";
                key = "t_bylayer";
            }
            : row {
	            : button {
	                label = /*MSG4*/"유형...";
	                key = "bn_type";
	            }
	            : text {
	                key = "tx_type";
	                width = 8;
	            }
            }
        }
    }
}

properties : column {
    :row {
        : column {
            fixed_width = true;
            : row {
                : button {
                    label = /*MSG2*/"색...";
                    mnemonic = /*MSG3*/"C";
                    key = "b_color";
                }
                : image_button {
                    key = "color_image";
                    height = 1;
                    width = 3;
                }
            }
            : button {
                label = /*MSG6*/"선...";
                mnemonic = /*MSG7*/"i";
                key = "b_line";
            }
            : button {
                label = /*MSG4*/"도면층...";
                mnemonic = /*MSG5*/"L";
                key = "b_name";
            }
        }
        : column {
            spacer_0;
            : text {
                key = "t_color";
                width = 20;
            }
            : text {
                key = "t_ltype";
                width = 20;
            }
            : text {
                key = "t_layer";
                width = 20;
            }
            spacer_0;
        }
        : column {
	    fixed_height = true;
            spacer_0;
            : toggle {
                label = /*MSG24*/" bylayer ";
                key = "c_bylayer";
            }
            spacer_0;
            : toggle {
                label = /*MSG25*/" bylayer ";
                key = "t_bylayer";
            }
            spacer_1;
            spacer_1;
        }
    }
}

prop_c_la : column {
    :row {
        : column {
            fixed_width = true;
            : row {
                : button {
                    label = /*MSG2*/"색...";
                    mnemonic = /*MSG3*/"C";
                    key = "b_color";
                }
                : image_button {
                    key = "color_image";
                    height = 1;
                    width = 3;
                }
            }
            : button {
                label = /*MSG4*/"도면층...";
                mnemonic = /*MSG5*/"L";
                key = "b_name";
            }
        }
        : column {
            spacer_0;
            : text {
                key = "t_color";
                width = 20;
            }
            : text {
                key = "t_layer";
                width = 20;
            }
            spacer_0;
        }
        : column {
		    fixed_height = true;
            spacer_0;
            : toggle {
                label = /*MSG24*/" bylayer ";
                key = "c_bylayer";
            }
            spacer_1;
            spacer_1;
        }
    }
}

th_el_edit_box : row {
    children_fixed_width = true;
    : edit_box_8 {
        key = "eb_thickness";
        label = /*MSG8*/"Thickness:";
    }
    spacer;
    : edit_box_8 {
        key = "eb_elevation";
        label = /*MSG22*/"Elevation:";
    }
}

width_edit_box : row {
    children_fixed_width = true;
    : edit_box_8 {
        key = "left_width";
        label = /*MSG8*/"Left_width:";
    }
    : edit_box_8 {
        key = "right_width";
        label = /*MSG22*/"Right_width:";
    }
}

setltype : dialog {
    label = /*MSG12*/"선 종류 선택";
    image_block;
    : list_box {
        key = "list_lt";
        allow_accept = true;
    }
    : edit_box {
        key = "edit_lt";
        allow_accept = false;
        label = /*MSG13*/"선 :";
        mnemonic = /*MSG22*/"L";
        edit_limit = 31;
        allow_accept = true;
    }
    ok_cancel_err;
}

//-------- Subassemblies and prototypes shared across several dialogues -------
current_layer_name : concatenation {
    children_fixed_width = true;
    key = "clayer";
    : text_part {
        label = /*MSG15*/"현재 도면층 : ";
    }
    : text_part {
        key = "cur_layer";
        width = 35;
    }
}

current_type_name : concatenation {
    children_fixed_width = true;
    : text_part {
        label = /*MSG15*/"현재 유형 이름 : ";
    }
    : text_part {
        key = "current_type";
        width = 35;
    }
}

type_edit_field : row {
    children_fixed_width = true;
    : edit_box {
        label = /*MSG20*/"유형 이름:";
        mnemonic = /*MSG21*/"T";
        key = "ed_type_name";
        width = 12;
        edit_width = 12;
        edit_limit = 11;
        allow_accept = true;
    }
    : button {
        label = /*MSG4*/"새 유형";
        mnemonic = /*MSG5*/"N";
        key = "eb_new_type";
        width = 12;
    }
    : button {
        label = /*MSG4*/"삭제";
        mnemonic = /*MSG5*/"D";
        key = "eb_del_type";
        width = 12;
    }
    : button {
        label = /*MSG4*/"이름 바꾸기";
        mnemonic = /*MSG5*/"R";
        key = "eb_ren_type";
        width = 12;
    }
}

basic_type_item : row {
    : text {
        label = /*MSG16*/"Type Name";
        width = 9;
    }
    : text {
        label = /*MSG16*/"Layer Name";
        width = 9;
    }
    : text {
        label = /*MSG18*/"Color";
        width = 9;
    }
    : text {
        label = /*MSG19*/"Linetype";
        width = 9;
    }
}

//-------------------- Sub Dialogues --------------------
setlayer : dialog {
    subassembly = 0;
    label = /*MSG14*/"도면층 선택";
    initial_focus = "listbox";
    current_layer_name;
    : row {
        fixed_width = true;
        key = "titles";
        children_fixed_width = true;
        : text {
            label = /*MSG16*/"도면층";
            width = 16;
        }
        : text {
            label = /*MSG17*/"상태";
            width = 10;
        }
        : text {
            label = /*MSG18*/"색";
            width = 9;
        }
        : text {
            label = /*MSG19*/"선";
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
	   
	        label = /*MSG20*/"현재 도면층 :";
	        mnemonic = /*MSG21*/"S";
	        key = "edit_lay";
	        allow_accept = true;
	    }
	    spacer_1;
	   //spacer_1;
//        : button {
//            label = /*MSG4*/"이름 바꾸기";
//            mnemonic = /*MSG5*/"R";
//            key = "ren_lay";
//            width = 12;
//            fixed_width = true;
//        }
    }
    ok_cancel_err;
}

set_prop : dialog {
    label = /*MSG1*/"속성 설정";
    :boxed_column {
    label = "속성";
    properties;
    }
    th_el_edit_box;
    
    ok_cancel_err;
}
set_prop_c_la : dialog {
    label = /*MSG1*/"속성 설정";
    :boxed_column {
    label = "속성";
    prop_c_la;
    }
    ok_cancel_err;
}
set_prop_c_la_li : dialog {
    label = /*MSG1*/"속성 설정";
    :boxed_column {
    label = "속성";
    properties;
    }
    ok_cancel_err;
}
