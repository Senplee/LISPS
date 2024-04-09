// 작업날짜: 2000년 5월 31일
// 작업자: 박율구
// 명령어: CIMDE (입면문 그리기에서 사용하는 DCL)

@include "setprop.dcl"

attribute : radio_row {
         key = "rd_attribute";
       : radio_button {
           label = "문틀";
           key = "rd_frame";
       }
       : radio_button {
           label = "열림표시";
           key = "rd_open";
       }
       : radio_button {
           label = "OutLine";
           key = "rd_outline";
       }
   
}    

door_image : boxed_column {
               label = "문 유형";
               :image {
                    key = "door_type";
                    height = 10;
                    width = 25;
                    color = 0;
               }     
           }

frame_option : boxed_column {
           label = "선택사항";  
             : row {
                 
                 : toggle {
                      label = "문틈 그리기:";
                      key = "tg_gap";
                      fixed_width = true;
                 }
                 : edit_box {
                      key = "ed_gap";
                      edit_width = 10;
                      fixed_width = true;
                 }
             }
             : row {
                 : toggle {
                      label = "문턱그리기";
                      key = "tg_threshold";
                      fixed_width = true;
                 }
                 spacer_0;
             }
             : edit_box {
                 label = "문틀 두께:";
                 key = "ed_frame";
                 fixed_width = true;
                 edit_width = 10;
                 alignment = right;
             }
             : edit_box {
                 label = "Finish Height:";
                 key = "ed_finish";
                 fixed_width = true;
                 edit_width = 10;
                 alignment = right;
             }
             : row {
                 : button {
                      label = "손잡이";
                      key = "bn_door";
                      height = 3;
                      width = 5;
                 }
                 : image {
                      key = "door_ring";
                      height = 1;
                      fixed_width = true;
                      width = 7;
                      color = 0;
                 }
             }
}   

//-------------------- Main Dialogues --------------------
dd_de : dialog {
        label = "입면 문 그리기";
    : boxed_column {
        label = "특성";
    properties;
    : spacer { height = 0.1;}
    attribute;
    }  
    //attribute;
    : row {
        door_image;
        frame_option;
    }
    : boxed_column {
        label = "문 선택사항";
        : row {
            : toggle {
                 label = "문틀 가로 크기:";
                 key = "tg_open_width";
            }
            : edit_box {
                 key = "ed_open_width";
                 fixed_width = true;
                 edit_width = 10;
            }
            : toggle {
                 label = "문틀 세로 크기:";
                 key = "tg_open_height";
            }
            : edit_box {
                 key = "ed_open_height";
                 fixed_width = true;
                 edit_width = 10;
            }
        }
        : row {
            : toggle {
                 label = "문 가로 크기 :";
                 key = "tg_door_width";
            }
            : edit_box {
                 key = "ed_door_width";
                 fixed_width = true;
                 edit_width = 10;
            }
            : toggle {
                 label = "문 세로 크기 :";
                 key = "tg_door_height";
            }
            : edit_box {
                 key = "ed_door_height";
                 fixed_width = true;
                 edit_width = 10;
            } 
        }
        : spacer { height = 0.1;}
            
    }
    ok_cancel;
    errtile;
} 

//-------------------- Sub Dialogues --------------------
dd_de_sub : dialog {
            label = "Door Handle";
            : boxed_column {
               label = "Door Ring Type";
                 : row {
                     :image_button {
                         key = "door1";
                         height = 3;
                         aspect_ratio = 1;
                         color = 0;
                     }
                     :image_button {
                         key = "door2";
                         height = 3;
                         aspect_ratio = 1;
                         color = 0;
                     }
                     :image_button {
                         key = "door3";
                         height = 3;
                         aspect_ratio = 1;
                         color = 0;
                     }     
                 }
                 : row {
                     :image_button {
                         key = "door4";
                         height = 3;
                         aspect_ratio = 1;
                         color = 0;
                     }
                     :image_button {
                         key = "door5";
                         height = 3;
                         aspect_ratio = 1;
                         color = 0;
                     }
                     : spacer {
                         height = 3;
                         aspect_ratio = 1;
                     }
                 }    
             }
             ok_cancel;
}             