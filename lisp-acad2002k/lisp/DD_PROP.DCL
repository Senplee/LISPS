/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   DD_PROP.DCL   Version 1.0
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
// Corresponding dialogues for ***.LSP which is an AutoLISP implementation
// of the AutoCAD Insert command with a dialogue interface.
//
//----------------------------------------------------------------------------


dcl_settings : default_dcl_settings { audit_level = 0; }


setltype : dialog {
    label = /*MSG1*/"Select Linetype";
    image_block;
    : list_box {
        key = "list_lt";
        allow_accept = true;
    }
    : edit_box {
        key = "edit_lt";
        allow_accept = false;
        label = /*MSG2*/"Linetype:";
        edit_limit = 31;
        mnemonic = /*MSG3*/"L";
    }
    ok_cancel_err;
}

setlayer : dialog {
    subassembly = 0;
    label = /*MSG4*/"Select Layer";
    initial_focus = "listbox";
    : concatenation {
        children_fixed_width = true;
        key = "clayer";
        : text_part {
            label = /*MSG5*/"Current Layer: ";
            width = 15;
        }
        : text_part {
            key = "cur_layer";
            width = 35;
        }
    }
    : row {
        fixed_width = true;
        key = "titles";
        children_fixed_width = true;
        : text {
            label = /*MSG6*/"Layer Name";
            width = 34;
        }
        : text {
            label = /*MSG7*/"State";
            width = 9;
        }
        : text {
            label = /*MSG8*/"Color";
            width = 8;
        }
        : text {
            label = /*MSG9*/"Linetype";
            width = 12;
        }
    }
    : list_box {
        tabs = "32 35 37 39 41 44 53";
        width = 67;
        height = 12;
        key = "list_lay";
        allow_accept = true;
    }
    : row {
        key = "controls";
        : column {
            key = "lname";
            fixed_width = true;
            : edit_box {
                label = /*MSG10*/"Set Layer Name:";
                mnemonic = /*MSG11*/"S";
                key = "edit_lay";
                width = 32;
                edit_width = 32;
                edit_limit = 31;
                allow_accept = true;
            }
        }
    }
    ok_cancel_err;
}
