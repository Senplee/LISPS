/* Next available MSG number is  41 */

//----------------------------------------------------------------------------
//
//   DD_LIB.DCL   Version 1.0
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
// Corresponding dialogues for SYM1.LSP which is an AutoLISP implementation
// of the AutoCAD Insert command with a dialogue interface. 
//
//----------------------------------------------------------------------------


@include "setprop.dcl"

lib_options : row {
    //label = /*MSG1*/"Library_Options";
    : boxed_column {
        label = /*MSG2*/"단열재 종류";
        : row {
            : image {
                key = "ins_type";
                height       = 5;
                aspect_ratio = 1.2;
                color        = 0;
            }
            spacer;
            : radio_column {
                spacer;
                : radio_button {
                    label = /*MSG3*/"Line";
                    mnemonic = /*MSG4*/"n";
                    key = "line";
                }
                : radio_button {
                    label = /*MSG5*/"Curve";
                    mnemonic = /*MSG6*/"v";
                    key = "curve";
                }
                spacer;
            }
        }
    }
    : column {        
        : row {
            : toggle {
                key = "tg_thick";
                label= "Thickness"; 
            }
            : edit_box {
               key = "l_thickness";
               //label = /*MSG13*/"Thickness   :";
               mnemonic = /*MSG14*/"T";
               edit_width = 12;
            }
        }    
    }
}


dd_ins : dialog {
    label = /*MSG26*/"공간벽 단열재 그리기";
    : boxed_column {
        label = /*MSG2*/"특 성";
    	prop_c_la;
    }
    lib_options;        
    ok_cancel_err;
}