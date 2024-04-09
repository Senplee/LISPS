// 작업날짜: 2000년 6월 8일
// 작업자: 박율구
// 명령어: CIMMCD (안목치수 그리기에서 사용하는 DCL)

@include "setprop.dcl"

mcd : dialog {
	label = "안목치수 기입하기";
	:boxed_row{
   		label="특성";
		:column{
			:row{
				:button{ label="Color"; key="bn_color"; width=13; fixed_width=true;}
				:image_button{ key="color_image"; width=4.0; aspect_ratio=1.0; fixed_width=true;}
				:text{ key="t_color"; width=15;}
				:toggle{ label="Bylayer"; key="c_bylayer";}
			}
			:row{
				:button{ label="Layer"; key="bn_layer";  width=13; fixed_width=true;}
				:text{ key="t_layer"; width=12; alignment=left; }
				:spacer{width=20;}
			}
			:row{
				spacer_1;
				:radio_row{ key="rd_laycol";
				     :radio_button{ label="심볼"; key="rd_symbol";}
				     :radio_button{ label="치수"; key="rd_dimension";}
				}     
				spacer_1;
			}
		}
	}
   	:row{
    	:column{
    		:boxed_row{
    			label="공간대";
    			:column{
    				:image_button{ key="img_space"; width=22; aspect_ratio=0.75; color=0; fixed_height=true; }
    				:text{ key="txt_module"; alignment=center;}
    			}
    		}
    	}
    	:column{
    		:boxed_row{
    			label="방향";
    			        :radio_row{ key="rd_direction";
	   			     :radio_button{ label="수평";  key="rd_hor";}
				     :radio_button{ label="수직";  key="rd_ver";}
				     :radio_button{ label="기울기";  key="rd_ali";}
				}     
    		}
    		:boxed_column{
    			label="기호/치수";
    			:row{
	    			:edit_box{ label="기호크기:"; key="ed_size"; edit_width=4;}
	    			:spacer{width=8;}
	    		}		
	    		:row{
    				:popup_list{ label="기호표시:";key="pop_position"; list="없음\n왼쪽\n오른쪽\n양쪽";edit_width=11;}
    				spacer_1;
    			}
    			:row{
    				:popup_list{ label="치수유형:";key="pop_dim";edit_width=11;}
    				spacer_1;
    			}
    		}
    	}
    	
   	}
   	ok_cancel;
   	spacer_1;
}   

