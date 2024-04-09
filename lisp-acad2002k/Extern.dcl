WELD : dialog {
    label = "Weld Mark";
        : row {
        : column {
            : image_button {                        
                key = "fu_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;               
                color = 0;
             }                                      
            : image_button {                        
                key = "ku_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;               
                color = 0;
             }
            : image_button {
                key = "vu_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;
                color = 0;
             }
        }
        : column {    
            : image_button {
                key = "fl_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;
                color = 0;
             }
            : image_button {
                key = "kl_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;
                color = 0;
             }
            : image_button {
                key = "vl_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;                 
                color = 0;
             }                                       
        }
        : column {    
            : image_button {
                key = "fb_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;
                color = 0;
             }
            : image_button {
                key = "kb_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;
                color = 0;
             }
            : image_button {
                key = "vb_weld";
                width = 6;
                fixed_height = 4;
                allow_accept = false;
                color = 0;
             }
        }
        : column {
          : edit_box {
              label = "Weld Size:";
              key = "wsize";
              edit_width = 2;
              allow_accept = false;
          }
          : edit_box {
              label = "Groove Angle:";
              key = "gangle";
              edit_width = 2;
              allow_accept = false;
          }
          : edit_box {
              label = "Gap of root:";
              key = "groot";
              edit_width = 2;
              allow_accept = false;
          }
          : toggle {
              label = "Weld All Around";
              key = "round";
          }
          : toggle {
              label = "Field Weld";
              key = "field";
          }
        }
}
    spacer;
    ok_cancel;
}    

