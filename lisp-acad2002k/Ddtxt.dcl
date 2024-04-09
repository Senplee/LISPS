/*TIP1129.DCL: DDTXT.DCL   Edit Multiple Text Lines   (c)1995, Shaun Seela*/

/* Copyright (C) 1991-1992 by Autodesk, Inc. */
ddtxt : dialog {
    key = "ddtxt_top";
    initial_focus = "edit_1";
    : row {
       alignment = right;
       fixed_width = true;
      : text_part {
         label = "Selected items:";
      }
      : text {
         key = "items";
         children_alignment = right;
         fixed_width = true;
         width = 4;
      }    
    }
    spacer_1;    
    number = "10";  /* needs to be a string */
    /*  The number of prompt/edit pairs should match the "number" setting. */
    : row {
        : text {
            key = "prompt_1"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_1";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_2"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_2";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_3"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_3";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_4"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_4";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_5"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_5";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_6"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_6";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_7"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_7";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_8"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_8";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_9"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_9";   edit_width = 50;  edit_limit = 255;
        }
    }
    : row {
        : text {
            key = "prompt_10"; width = 10; fixed_width = true;
        }
        : edit_box {
            key = "edit_10";  edit_width = 50;  edit_limit = 255;
        }
    }
     : row {
       : boxed_row {
          fixed_width = true;
          alignment = centered;       
           : button {
              key = "upper";
              label = "Upper Case";
           }
           : button {
              key = "lower";
              label = "Lower Case";
           }
       }
       : boxed_row {
         : button {
            key = "prev";
            label = "Previous";
         }
         : button {
            key = "next";
            label = " Next ";
         }
       }
     }
    spacer_1;
    : row {       
      : row {
         fixed_width = true;
         alignment = left;
         : row {
           : spacer { width = 2; }
              alignment = left;
              fixed_width = true;
           spacer_1;
           : text_part {
              label = "Page ";
           }
           : text {
              key = "pageof";
              children_alignment = left;
              fixed_width = true;
              width = 10;
           }
         }        
      }
     ok_cancel;
    }            
    :boxed_row {
      label="Sorting Option's";
      key="sort_k";
      :button {
        label="T to B";
        key="sort_k1";
      }
      :button {
        label="B to T";
        key="sort_k2";
      }
      :button {
        label="L to R";
        key="sort_k3";
      }
      :button {
        label="Never";
        key="sort_k4";
      }
    }
}
