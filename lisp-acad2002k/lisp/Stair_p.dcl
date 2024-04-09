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
        label = /*MSG54*/"��� ����";
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
    label = /*MSG8*/"�����";
    : edit_box {
            key = "l_depth";
            label = /*MSG55*/"����� �� :";
            mnemonic = /*MSG56*/"p";
            edit_width = 8;
        }
    : edit_box {
        key = "t_number";
        label = /*MSG9*/"�� �� �� :";
        mnemonic = /*MSG10*/"N";
        edit_width = 8;
    }
    : edit_box {
        key = "t_width";
        label = /*MSG11*/"�� �� �� :";
        mnemonic = /*MSG12*/"W";
        edit_width = 8;
    }
    : edit_box {
        key = "g_size";
        label = /*MSG13*/"������� :";
        mnemonic = /*MSG14*/"G";
        edit_width = 8;
    }
}

hand_options : boxed_column {
    //fixed_width = true;
    label = /*MSG15*/"���� ����";
    : toggle {
        key = "handrail";
        label = /*MSG16*/"���� �׸���";
        mnemonic = /*MSG17*/"H";
        fixed_width = true;
    }
    
    : edit_box {
        key = "h_width";
        label = /*MSG20*/"���� ���� :";
        mnemonic = /*MSG21*/"t";
        edit_width = 8;
    }

}

slip_options : boxed_column {
    //fixed_width = true;
    label = /*MSG22*/"���� ���";
    : toggle {
        key = "nonslip";
        label = /*MSG23*/"����";
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
        label = /*MSG27*/"��  :";
        mnemonic = /*MSG28*/"h";
        edit_width = 8;
    }
}

arrow_options : boxed_column {
    fixed_width = true;
    label = /*MSG29*/"ȭ��ǥ ���û���";
    : row {
	    : toggle {
	        key = "section";
	        label = /*MSG30*/"�ܸ� ǥ��";
	        mnemonic = /*MSG31*/"m";
	        fixed_width = true;
	    }
	    : toggle {
	        key = "arrow";
	        label = /*MSG32*/"���� ǥ��";
	        mnemonic = /*MSG33*/"A";
	        fixed_width = true;
	    }
	}
    : edit_box {
        key = "a_size";
        label = /*MSG34*/"ũ��:";
        mnemonic = /*MSG35*/"z";
        edit_width = 8;
    }

}

dan_option:  boxed_column {
    label = /*MSG29*/"����ǥ�� ���û���";
    : row {
        : toggle {
            key = "up";
            label = /*MSG36*/"����ǥ��";
            mnemonic = /*MSG37*/"U";
            fixed_width = true;
        }
        : toggle {
            key = "down";
            label = /*MSG38*/"����ǥ��";
            mnemonic = /*MSG39*/"D";
            fixed_width = true;
        }
    }
    : edit_box {
        key = "t_size";
        label = /*MSG40*/"���� ũ��:";
        mnemonic = /*MSG41*/"x";
        edit_width = 8;
    }
}

stp_prop : boxed_column {
    label = /*MSG2*/"Ư��";
    prop_type;
   // th_el_edit_box;
    stp_prop_radio;
}
stp_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"�ɺ�";
        key = "rd_symbol";
    }
    : radio_button {
        label = /*MSG5*/"����";
        key = "rd_handrail";
    }
    : radio_button {
        label = /*MSG3*/"����";
        key = "rd_nonslip";
    }
    : radio_button {
        label = /*MSG5*/"���";
        key = "rd_stair";
    }
}


dd_stp : dialog {
    
    label = /*MSG53*/"��� ���";
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