select_layer : dialog {
   label = "������ ����";
   : column {
     : list_box {
       label        = "������ ���";
       key          = "layer_list";
       width        = 16;
       height       = 10;
       allow_accept = true;
     }
     : edit_box {
       label        = "������ �̸�:";
       key          = "layer_edit";
       width 	    = 16;		
       edit_width   = 10;
     }
     spacer; 
     ok_cancel;
   }
}