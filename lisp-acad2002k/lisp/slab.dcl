//---------------------------------------------------------------------------------
// SLAB.DCL
//---------------------------------------------------------------------------------

slab : dialog {
   label = "슬라브 일람표";
   :row{
        :list_box{
			tabs="6 9 14 25 36 47 58 69 80 91 102 113 124 135";
			tab_truncate = true;
		    label="부호 TYPE THK        X1                  X2                   X3                  X4                  X5                  Y1                  Y2                  Y3                  Y4";
			key="list_type"; width = 58; height = 6;
		 }
   }
   :row{
   		:boxed_column{
			label="Type";
			fixed_width=true;
			:image{ key="type"; width=50; color=0; aspect_ratio=0.65; fixed_width=true; fixed_height=true;}
			:radio_row{
				key="rd_type";
				:radio_button{ label="A"; key="atype";}
   				:radio_button{ label="B"; key="btype";}
   				:radio_button{ label="C"; key="ctype";}
   				:radio_button{ label="D"; key="dtype";}
   				:radio_button{ label="E"; key="etype";}
				
			}	
   		}
   	:column{
		:boxed_column{
			label="슬라브 데이타";
			:row{
				:edit_box{ label="슬라브 부호:"; key="ssym"; edit_width=5;alignment=left;}
				:edit_box{ label="슬라브 두께:"; key="sthk"; edit_width=5;alignment=left;}	
			}
            		:row{
				:boxed_column{
					label="단변(Lx)";
					:edit_box{ label="X1:"; key="x1"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X2:"; key="x2"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X3:"; key="x3"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X4:"; key="x4"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X5:"; key="x5"; edit_width=12; fixed_width=true;}
				}
				:boxed_column{
					label="장변(Ly)";
					:edit_box{ label="Y1:"; key="y1"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y2:"; key="y2"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y3:"; key="y3"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y4:"; key="y4"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y5:"; key="y5"; edit_width=12; fixed_width=true;}
				}
   			}
		}
		:boxed_row{
			label="글자 크기";
			:edit_box{ label="제목:"; key="height3"; edit_width=6; fixed_width=true;}
			:edit_box{ label="항목:"; key="height1"; edit_width=6; fixed_width=true;}
			:edit_box{ label="내용:"; key="height2"; edit_width=6; fixed_width=true;}
			}
	}
   }
   :row{
		:button{ label="추가"; key="append"; width=8;}
   		:button{ label="수정"; key="modify"; width=8;}
		:button{ label="삽입"; key="insert"; width=8;}
   		:button{ label="삭제"; key="delete"; width=8;}
		:button{ label="화일열기"; key="open";   width=8;}
   		:button{ label="저장하기"; key="save";   width=8;}
   }
   spacer_1;
   :row {
      fixed_width=true;
      alignment = centered;
      :button { fixed_width = true; label="그리기"; key="ok";   width=12; }
      :button { fixed_width = true; label="취소"; key="cancel"; width=12; is_cancel=true; }
      //:button { fixed_width = true; label="도움말"; key="help";   width=12; }
   }

}   
