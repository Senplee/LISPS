/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   STAIR_S.DCL   Version 1.0
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
// Corresponding dialogues for STC.LSP which is an AutoLISP implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------
@include "setprop.dcl"



stc_options : boxed_column {
   // label = /*MSG1*/"특성";
   // : boxed_column {
        fixed_width = true;
        label = /*MSG2*/"계단 선택";
        : row {
         :column {
            : image {
                key = "stc_type";
                //fixed_height = true;
                height       = 6;
                aspect_ratio = 1.2;
                color        = 0;
            }
            spacer;
            }
            : radio_column {
                spacer;
                : radio_button {
                    label = /*MSG3*/"단면";
                    mnemonic = /*MSG4*/"S";
                    key = "section";
                }
                : radio_button {
                    label = /*MSG5*/"입면";
                    mnemonic = /*MSG6*/"E";
                    key = "elevation";
                }
                spacer;
                spacer;
            }
            
        }
    }

slab_options : boxed_row {
    fixed_width = true;
    label = /*MSG15*/"슬라브";
    : column {
	    : row {
	        : text {
	            key = "t_step";
	            width = 8;
	        }
	        : image_button {
	            fixed_width = true;
	            key = "step_1";
	            height = 3;
	            aspect_ratio = 1.3;
	            color = 0;
	        }
	        : image_button {
	            fixed_width = true;
	            key = "step_2";
	            height = 3;
	            aspect_ratio = 1.3;
	            color = 0;
	        }
	    }
	    : edit_box {
	            key = "r_number";
	            label = /*MSG13*/"디딤판 개수 :";
	            mnemonic = /*MSG14*/"R";
	            edit_width = 10;
	        }
	    : edit_box {
	        key = "t_gap";
	        label = /*MSG16*/"간     격 :";
	        mnemonic = /*MSG17*/"e";
	        edit_width = 10;
	    }
    }
    :column {
    		//spacer;
	    : edit_box {
	        key = "s_thick";
	        label = /*MSG18*/"두     께 :";
	        mnemonic = /*MSG19*/"S";
	        edit_width = 10;
	    }
	    : edit_box {
	        key = "top_thick";
	        label = /*MSG20*/"상부 마감두께 :";
	        mnemonic = /*MSG21*/"T";
	        edit_width = 10;
	    }
	    : edit_box {
	        key = "bot_thick";
	        label = /*MSG22*/"하부 마감두께 :";
	        mnemonic = /*MSG23*/"B";
	        edit_width = 10;
	    }
    }
}

hand_options : boxed_column {
    fixed_width = true;
    label = /*MSG24*/"난간";
    : toggle {
        key = "handrail";
        label = /*MSG25*/"난간 그리기";
        mnemonic = /*MSG26*/"H";
        fixed_width = true;
    }
    : row {
        : image_button {
            fixed_width = true;
            key = "hand_1";
            height = 3;
            aspect_ratio = 1.3;
            color = 0;
        }
        : image_button {
            fixed_width = true;
            key = "hand_2";
            height = 3;
            aspect_ratio = 1.3;
            color = 0;
        }
        : image_button {
            fixed_width = true;
            key = "hand_3";
            height = 3;
            aspect_ratio = 1.3;
            color = 0;
        }
    }

    : edit_box {
        key = "h_height";
        label = /*MSG29*/"난간 높이    :";
        mnemonic = /*MSG30*/"H";
        edit_width = 12;
    }
    : edit_box {
        key = "h_depth";
        label = /*MSG31*/"난간 위치     :";
        mnemonic = /*MSG32*/"D";
        edit_width = 12;
    }
}

stc_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
   // th_el_edit_box;
    stc_prop_radio;
}
stc_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"난간";
        key = "rd_handrail";
    }
    : radio_button {
        label = /*MSG3*/"마감선";
        key = "rd_finish";
    }
    : radio_button {
        label = /*MSG5*/"슬라브";
        key = "rd_slab";
    }
}
dd_stc : dialog {
    label = /*MSG44*/"계단 입면,단면";
    stc_prop;
    :row{
    stc_options;
    hand_options;
    }
    spacer;
    
        slab_options;
    
    spacer;
    ok_cancel_err;
}
