// �۾���¥: 2000�� 6�� 8��
// �۾���: ������
// ��ɾ�: CIMMCD (�ȸ�ġ�� �׸��⿡�� ����ϴ� DCL)

@include "setprop.dcl"

mcd : dialog {
	label = "�ȸ�ġ�� �����ϱ�";
	:boxed_row{
   		label="Ư��";
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
				     :radio_button{ label="�ɺ�"; key="rd_symbol";}
				     :radio_button{ label="ġ��"; key="rd_dimension";}
				}     
				spacer_1;
			}
		}
	}
   	:row{
    	:column{
    		:boxed_row{
    			label="������";
    			:column{
    				:image_button{ key="img_space"; width=22; aspect_ratio=0.75; color=0; fixed_height=true; }
    				:text{ key="txt_module"; alignment=center;}
    			}
    		}
    	}
    	:column{
    		:boxed_row{
    			label="����";
    			        :radio_row{ key="rd_direction";
	   			     :radio_button{ label="����";  key="rd_hor";}
				     :radio_button{ label="����";  key="rd_ver";}
				     :radio_button{ label="����";  key="rd_ali";}
				}     
    		}
    		:boxed_column{
    			label="��ȣ/ġ��";
    			:row{
	    			:edit_box{ label="��ȣũ��:"; key="ed_size"; edit_width=4;}
	    			:spacer{width=8;}
	    		}		
	    		:row{
    				:popup_list{ label="��ȣǥ��:";key="pop_position"; list="����\n����\n������\n����";edit_width=11;}
    				spacer_1;
    			}
    			:row{
    				:popup_list{ label="ġ������:";key="pop_dim";edit_width=11;}
    				spacer_1;
    			}
    		}
    	}
    	
   	}
   	ok_cancel;
   	spacer_1;
}   

