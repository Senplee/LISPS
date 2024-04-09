chtgr1 
: dialog {
label = "CHange of Text GRoup (CHTGR), release 1.4";
	: boxed_row {
	label = "Properties";
        	: column {
		      : edit_box {
                	label = "Height ------->";
                	edit_width = 10;
                	key = "hght";
			}//edit_box
            	
			: edit_box {
                	label = "Rotation ----->";
                	edit_width = 10;
                	key = "rot";
            	}//edit_box

            	: edit_box {
                	label = "Width Factor ->";
                	edit_width = 10;
                	key = "wid";
            	}//edit_box

            	: edit_box {
                	label = "Obliquing ---->";
                	edit_width = 10;
                	key = "obl";
            	}//edit_box
        	}//column

		spacer_1;

        	: column {
            	: popup_list {
                	label = "  Justify ->";
                	key = "just";
			value = "";
                	edit_width = 13;
            	}

            	: popup_list {
                	label = "  Style --->";
                	key = "tstyle";
			value = "";
                	edit_width = 13;
            	}

            	: column {
                		: toggle {
                    	label = "Upside Down";
                    	key = "upsd";
                		}

                		: toggle {
                    	label = "Backward";
                    	key = "bkwd";
                		}

                		: toggle {
                		label = "Enable Edit Text";
                		key = "dotxt";
                		}
            	}//column
        	}//column
    	}//boxed_row
	:text {
	label = "For leaving previous value of parameter - set field to VARIES";
	}

      spacer_1;

      :boxed_column {
      label = "Edit Text";
      key = "redtxt";
           	: edit_box {
            label = "Text: ";
            key = "t_string";
            edit_limit = 128;
           	}//edit_text

   		:row {
      		: button {
       		label = "< Previous >";
       		key = "prevt";
      		}//button

      		: button {
       		label = "< Next >";
       		key = "nextt";
      		}

      		: button {
       		label = "< Replace >";
       		key = "updt";
      		}
   		}//row

  	}//boxed_column

   		:text_part {
   		key = "rem";
   		} 
     	ok_cancel_help_info;

}//dialog

info_gs
: dialog{
label = "Information";
:text_part {
label = "Author: GlorySoft";
}//text_part
spacer_1;

: edit_box {
label = "E-mail: ";
width = 28;
value = "burlakov@infopac.ru";
}
spacer_1;
ok_only;
}//dialog

shareware 
: dialog {
    label = "shareware";
    value = "   ShareWare program";
    : boxed_column {
        label = "Warning.";
        mnemonic = "Â"";
        : text {
            label = "t1";
            value = "This window appears in the unregistered program only.";
            fixed_height = false;
            width = 60;
        }
        : text {
            label = "å2";
            value = "Read file ReadMe.txt for information";
        }
    }
  : spacer {}
  : row {
        : text {
            label = "text";
            value = "Remained, sek";
        }
        : text {
            label = "text1";
            key = "text1";
            value = "10";
        }
    }
 
    : slider {
        key = "sek";
        value = "10";
        big_increment = "1";
        max_value = 10;
        min_value = 0;
        small_increment = 1;
        width = 41;
    }
    ok_only;
}
