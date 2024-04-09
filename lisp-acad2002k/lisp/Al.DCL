// 작업날짜: 2000년 6월 20일
// 작업자: 박율구
// 명령어: CIMAL 

@include "setprop.dcl"

al : dialog {
	label = "호,원의 길이삽입";
	:boxed_row{
	        :column{
	                :text{key="t_top"; height=2; is_bold=true;}
	                :text{key="t_top2"; height=2; is_bold=true;}
	        }        
	}        
	:boxed_row{
   		label="특성";
		prop_c_la;
	}
	:boxed_row {
	        label="Drawing";
	        :column {
	                :row{
	                   :column{
	                      :toggle{label="삽입여부"; key="tg_insert";}
	                      spacer_1;
	                   }
	                   :radio_column{
	                       :radio_button{key="rd_arc";label="호길이";}
	                       :radio_button{key="rd_cir";label="원주";}
	                   }
	                }   
	                :row{:toggle{label="단위표기"; key="tg_unit";}
	                     :popup_list{key="pop_unit";width=7;edit_width=7;}
	                }     
	                spacer_1;
                 }
                 spacer_0;
                :column {
                        :edit_box{label="소수점 자리수:"; key="ed_point"; edit_width=5;}
                        :edit_box{label="글자크기:"; key="ed_size"; edit_width=5;}
                        :edit_box{label="글자각도:"; key="ed_angle"; edit_width=5;}
                        spacer_1;
                 }
         }
         ok_cancel;
         spacer_1;
}