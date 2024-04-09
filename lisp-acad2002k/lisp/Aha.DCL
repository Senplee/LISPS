// 작업날짜: 2000년 6월 20일
// 작업자: 박율구
// 명령어: CIMAHA 

@include "setprop.dcl"

aha : dialog {
	label = "면적 삽입";
	:boxed_row{
	        :text{key="t_top"; height=2; is_bold=true;}
	}        
	:boxed_row{
   		label="특성";
		prop_c_la;
	}
	:row {
	        :spacer { width= 1;}
	        :boxed_column {
	                label = "단위표기";
	                :radio_row {
	                      key="rd_unit";
	                      :radio_button{label="M2"; key="rd_m2";}
	                      :radio_button{label="평"; key="rd_py";}
	                }
	                :toggle{label="삽입여부"; key="tg_insert";}
                 }
                 :boxed_column {
                        label = "Text";
                        :edit_box{label="소수점 자리수:"; key="ed_point"; edit_width=5;}
                        :edit_box{label="글자크기:"; key="ed_size"; edit_width=5;}
                        :edit_box{label="글자각도:"; key="ed_angle"; edit_width=5;}
                 }
                 :spacer { width= 1;}
         }
         ok_cancel;
         spacer_1;
}	