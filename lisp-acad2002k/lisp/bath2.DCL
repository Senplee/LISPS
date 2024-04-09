// 작업날짜: 2000년 6월 19일
// 작업자: 김현주
// 명령어: FIXU (소변기 그리기에서 사용하는 DCL)

@include "setprop.dcl"
tt1_prop_radio : boxed_radio_row {
	key = "prop_radio";
    : radio_button {
        label = /*MSG5*/"변기";
        key = "rd_tt";
    }
    : radio_button {
        label = /*MSG5*/"파티션";
        key = "rd_partition";
    }
   
}
//소변기 평면도 dcl
dd_tt1:dialog{
	label="화장실 평면 그리기";	
	: boxed_column {
	label = "속성";
	prop_c_la;
	tt1_prop_radio;
	}
	: boxed_column {
	   label="좌변기 평면";
		: row {
			:image_button{
				key="cc-102p";
				width=7;
				height=5;					
				color=0;				
				allow_accept=true;
			}
			:image_button{
				key="cc-12p";
				width=7;
				height=5;					
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="cc-13p";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="cc-302p";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}
		}
		: row {
			:image_button{
				key="cc-102ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
			:image_button{
				key="cc-12ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
			:image_button{
				key="cc-13ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
			:image_button{
				key="cc-302ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
		}
		: row {
			: text {
				label = "파일 이름 : ";                		               		
           		 }
           		 spacer_1;   
           		: edit_box {				
                		key = "f_name";
               		 	width = 20;
           		 }
           		 : button {
                		label = "찾아보기...";                		
                		key = "f_search";                	
            		}
           		          		            	          		
		}
	}
	:boxed_row {
	
         : edit_box_8 {
	        key = "eb_frame_width";
	        label = /*MSG8*/"판넬 두께:";
	    }
          : toggle {
        	label = /*MSG26*/"간단히 그리기";
        	key = "tg_simple";
    		}
         }
	 ok_cancel_err;
}

