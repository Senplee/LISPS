//---------------------------------------------------------------------------------
// SLAB.DCL
//---------------------------------------------------------------------------------

slab : dialog {
   label = "����� �϶�ǥ";
   :row{
        :list_box{
			tabs="6 9 14 25 36 47 58 69 80 91 102 113 124 135";
			tab_truncate = true;
		    label="��ȣ TYPE THK        X1                  X2                   X3                  X4                  X5                  Y1                  Y2                  Y3                  Y4";
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
			label="����� ����Ÿ";
			:row{
				:edit_box{ label="����� ��ȣ:"; key="ssym"; edit_width=5;alignment=left;}
				:edit_box{ label="����� �β�:"; key="sthk"; edit_width=5;alignment=left;}	
			}
            		:row{
				:boxed_column{
					label="�ܺ�(Lx)";
					:edit_box{ label="X1:"; key="x1"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X2:"; key="x2"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X3:"; key="x3"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X4:"; key="x4"; edit_width=12; fixed_width=true;}
					:edit_box{ label="X5:"; key="x5"; edit_width=12; fixed_width=true;}
				}
				:boxed_column{
					label="�庯(Ly)";
					:edit_box{ label="Y1:"; key="y1"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y2:"; key="y2"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y3:"; key="y3"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y4:"; key="y4"; edit_width=12; fixed_width=true;}
					:edit_box{ label="Y5:"; key="y5"; edit_width=12; fixed_width=true;}
				}
   			}
		}
		:boxed_row{
			label="���� ũ��";
			:edit_box{ label="����:"; key="height3"; edit_width=6; fixed_width=true;}
			:edit_box{ label="�׸�:"; key="height1"; edit_width=6; fixed_width=true;}
			:edit_box{ label="����:"; key="height2"; edit_width=6; fixed_width=true;}
			}
	}
   }
   :row{
		:button{ label="�߰�"; key="append"; width=8;}
   		:button{ label="����"; key="modify"; width=8;}
		:button{ label="����"; key="insert"; width=8;}
   		:button{ label="����"; key="delete"; width=8;}
		:button{ label="ȭ�Ͽ���"; key="open";   width=8;}
   		:button{ label="�����ϱ�"; key="save";   width=8;}
   }
   spacer_1;
   :row {
      fixed_width=true;
      alignment = centered;
      :button { fixed_width = true; label="�׸���"; key="ok";   width=12; }
      :button { fixed_width = true; label="���"; key="cancel"; width=12; is_cancel=true; }
      //:button { fixed_width = true; label="����"; key="help";   width=12; }
   }

}   
