// �۾���¥: 2000�� 6�� 19��
// �۾���: ������
// ��ɾ�: FIXU (�Һ��� �׸��⿡�� ����ϴ� DCL)

@include "setprop.dcl"

//�Һ��� ��鵵 dcl
dd_fixu:dialog{
	label="�Һ��� ��鵵";	
	: boxed_column {
	label = "�Ӽ�";
	prop_c_la;
	}
	: boxed_column {
	   label="�Һ��� ���";
		: row {
			:image_button{
				key="keycu301p";
				width=7;
				height=5;					
				color=0;				
				allow_accept=true;
			}
			:image_button{
				key="keycu302p";
				width=7;
				height=5;					
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="keycu303p";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="keycu304p";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}
		}
		: row {
			:image_button{
				key="keycu301ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
			:image_button{
				key="keycu302ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
			:image_button{
				key="keycu303ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
			:image_button{
				key="keycu304ps";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;			
			}
		}
		: row {
			: text {
				label = "���� �̸� : ";                		               		
           		 }
           		 spacer_1;   
           		: edit_box {				
                		key = "f_name";
               		 	width = 20;
           		 }
           		 : button {
                		label = "ã�ƺ���...";                		
                		key = "f_search";                	
            		}
           		          		            	          		
		}
	}
	
	 ok_cancel;
}

//�Һ��� �Ը鵵 dcl
dd_fixue:dialog{
	label="�Һ��� �Ը鵵";
	: boxed_column {
	label = "�Ӽ�";
	prop_c_la;
	}
	: boxed_column {
	   label="�Һ��� �Ը�";
		: row {
			:image_button{
				key="keycu301e";
				width=5;
				height=5;
				aspect_ratio = 1;
				color=0;				
				allow_accept=true;
			}
			:image_button{
				key="keycu302e";
				width=5;
				height=5;
				aspect_ratio = 1;
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="keycu308e";
				width=5;
				height=5;
				aspect_ratio = 1;
				color=0;	
				allow_accept=true;		
			}			
		}
		: row {
			: text {
				label = "���� �̸� : ";                		               		 	
           		 }
           		 spacer_1;   
           		: edit_box {				
                		key = "f_name";
               		 	width = 20;
           		 }
           		 : button {
                		label = "ã�ƺ���...";                		
                		key = "f_search";                	
            		}
           		          		            	          		
		}		
	}
	
	 ok_cancel;
}

//����� ��鵵 dcl
dd_fixw:dialog{
	label="����� ��鵵";
	: boxed_column {
	label = "�Ӽ�";
	prop_c_la;
	}
	: boxed_column {
	   label="����� ���";
		: row {
			:image_button{
				key="keywshb1";
				width=7;
				height=5;				
				color=0;				
				allow_accept=true;
			}
			:image_button{
				key="keywshb2";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="keywshb3";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}						
		}
		: row {
			:image_button{
				key="keywshb1s";
				width=7;
				height=5;				
				color=0;				
				allow_accept=true;
			}
			:image_button{
				key="keywshb2s";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="keywshb3s";
				width=7;
				height=5;				
				color=0;	
				allow_accept=true;		
			}						
		}
		: row {
			: text {
				label = "���� �̸� : ";                		               		 	
           		 }
           		 spacer_1;   
           		: edit_box {				
                		key = "f_name";
               		 	width = 20;
           		 }
           		 : button {
                		label = "ã�ƺ���...";                		
                		key = "f_search";                	
            		}
           		          		            	          		
		}		
	}
	
	 ok_cancel;
}

//����� �Ը鵵 dcl
dd_fixwe:dialog{
	label="����� �Ը鵵";
	: boxed_column {
	label = "�Ӽ�";
	prop_c_la;
	}
	: boxed_column {
	   label="����� �Ը�";
		: row {
			:image_button{
				key="keycmwe";
				width=5;
				height=5;
				aspect_ratio = 1;
				color=0;				
				allow_accept=true;
			}
			:image_button{
				key="keycmwe2";
				width=5;
				height=5;
				aspect_ratio = 1;
				color=0;	
				allow_accept=true;		
			}
			:image_button{
				key="keycmwe3";
				width=5;
				height=5;
				aspect_ratio = 1;
				color=0;	
				allow_accept=true;		
			}		
		}	
		: row {
			: text {
				label = "���� �̸� : ";                		               		 	
           		 }           		 
           		: edit_box {				
                		key = "f_name";
               		 	width = 20;
           		 }
           		 : button {
                		label = "ã�ƺ���...";                		
                		key = "f_search";                	
            		}
           		          		            	          		
		}				
	}
	
	 ok_cancel;
}