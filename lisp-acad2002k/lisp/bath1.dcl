// 작업날짜: 2000년 6월 19일
// 작업자: 김현주
// 명령어: FIXU (소변기 그리기에서 사용하는 DCL)

@include "setprop.dcl"

//소변기 평면도 dcl
dd_fixu:dialog{
	label="소변기 평면도";	
	: boxed_column {
	label = "속성";
	prop_c_la;
	}
	: boxed_column {
	   label="소변기 평면";
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
	
	 ok_cancel;
}

//소변기 입면도 dcl
dd_fixue:dialog{
	label="소변기 입면도";
	: boxed_column {
	label = "속성";
	prop_c_la;
	}
	: boxed_column {
	   label="소변기 입면";
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
	
	 ok_cancel;
}

//세면기 평면도 dcl
dd_fixw:dialog{
	label="세면기 평면도";
	: boxed_column {
	label = "속성";
	prop_c_la;
	}
	: boxed_column {
	   label="세면기 평면";
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
	
	 ok_cancel;
}

//세면기 입면도 dcl
dd_fixwe:dialog{
	label="세면기 입면도";
	: boxed_column {
	label = "속성";
	prop_c_la;
	}
	: boxed_column {
	   label="세면기 입면";
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
				label = "파일 이름 : ";                		               		 	
           		 }           		 
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
	
	 ok_cancel;
}