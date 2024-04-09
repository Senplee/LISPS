select_layer : dialog {
   label = "도면층 선택";
   : column {
     : list_box {
       label        = "도면층 목록";
       key          = "layer_list";
       width        = 16;
       height       = 10;
       allow_accept = true;
     }
     : edit_box {
       label        = "도면층 이름:";
       key          = "layer_edit";
       width 	    = 16;		
       edit_width   = 10;
     }
     spacer; 
     ok_cancel;
   }
}