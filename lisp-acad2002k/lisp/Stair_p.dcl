/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   STAIR_P.DCL   Version 1.0
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
// Corresponding dialogues for STP.LSP which is an AutoLISP implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------

@include "setprop.dcl"


stp_image : column{
    : boxed_column {
        label = /*MSG54*/"계단 유형";
        : image {
            key = "stp_type";
            height       = 5;
            aspect_ratio = 1.2;
            color        = 0;
        }
    }
 }
tread_options : boxed_column {
//    fixed_width = true;
    label = /*MSG8*/"디딤판";
    : edit_box {
            key = "l_depth";
            label = /*MSG55*/"계단참 폭 :";
            mnemonic = /*MSG56*/"p";
            edit_width = 8;
        }
    : edit_box {
        key = "t_number";
        label = /*MSG9*/"계 단 수 :";
        mnemonic = /*MSG10*/"N";
        edit_width = 8;
    }
    : edit_box {
        key = "t_width";
        label = /*MSG11*/"디 딤 폭 :";
        mnemonic = /*MSG12*/"W";
        edit_width = 8;
    }
    : edit_box {
        key = "g_size";
        label = /*MSG13*/"디딤간격 :";
        mnemonic = /*MSG14*/"G";
        edit_width = 8;
    }
}

hand_options : boxed_column {
    //fixed_width = true;
    label = /*MSG15*/"난간 선택";
    : toggle {
        key = "handrail";
        label = /*MSG16*/"난간 그리기";
        mnemonic = /*MSG17*/"H";
        fixed_width = true;
    }
    
    : edit_box {
        key = "h_width";
        label = /*MSG20*/"난간 굵기 :";
        mnemonic = /*MSG21*/"t";
        edit_width = 8;
    }

}

slip_options : boxed_column {
    //fixed_width = true;
    label = /*MSG22*/"논슬립 사양";
    : toggle {
        key = "nonslip";
        label = /*MSG23*/"논슬립";
        mnemonic = /*MSG24*/"N";
        fixed_width = true;
    }
    : row {
        : image_button {
            fixed_width = true;
            key = "type_1";
            height = 3;
            aspect_ratio = 1.3;
            color = 0;
        }
        : image_button {
            fixed_width = true;
            key = "type_2";
            height = 3;
            aspect_ratio = 1.3;
            color = 0;
        }
    }
   
    : edit_box {
        key = "n_width";
        label = /*MSG27*/"폭  :";
        mnemonic = /*MSG28*/"h";
        edit_width = 8;
    }
}

arrow_options : boxed_column {
    fixed_width = true;
    label = /*MSG29*/"화살표 선택사항";
    : row {
	    : toggle {
	        key = "section";
	        label = /*MSG30*/"단면 표시";
	        mnemonic = /*MSG31*/"m";
	        fixed_width = true;
	    }
	    : toggle {
	        key = "arrow";
	        label = /*MSG32*/"진행 표시";
	        mnemonic = /*MSG33*/"A";
	        fixed_width = true;
	    }
	}
    : edit_box {
        key = "a_size";
        label = /*MSG34*/"크기:";
        mnemonic = /*MSG35*/"z";
        edit_width = 8;
    }

}

dan_option:  boxed_column {
    label = /*MSG29*/"문자표시 선택사항";
    : row {
        : toggle {
            key = "up";
            label = /*MSG36*/"오름표시";
            mnemonic = /*MSG37*/"U";
            fixed_width = true;
        }
        : toggle {
            key = "down";
            label = /*MSG38*/"내림표시";
            mnemonic = /*MSG39*/"D";
            fixed_width = true;
        }
    }
    : edit_box {
        key = "t_size";
        label = /*MSG40*/"문자 크기:";
        mnemonic = /*MSG41*/"x";
        edit_width = 8;
    }
}

stp_prop : boxed_column {
    label = /*MSG2*/"특성";
    prop_type;
   // th_el_edit_box;
    stp_prop_radio;
}
stp_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"심볼";
        key = "rd_symbol";
    }
    : radio_button {
        label = /*MSG5*/"난간";
        key = "rd_handrail";
    }
    : radio_button {
        label = /*MSG3*/"논슬립";
        key = "rd_nonslip";
    }
    : radio_button {
        label = /*MSG5*/"계단";
        key = "rd_stair";
    }
}


dd_stp : dialog {
    
    label = /*MSG53*/"계단 평면";
    stp_prop;
    
    spacer;
    : row {
        stp_image;
        tread_options;
        
    }
    spacer;
    : row {
       :column{
        arrow_options;
        dan_option;
        }
        :column{
        hand_options;
        slip_options;
        }
        
    }
    spacer;
    ok_cancel_err;
}
