dd_lload : dialog {
	label = "리습 올리기";
	
	: boxed_row {
		: list_box {
			label  = "자동으로 올려지는 리습파일 목록";
			key    = "lisp_list"; 
			width  = 50;
			height = 10;
		}

		:column {
			: spacer {
				height = 0.5;
			}
			: button {
				label  = "추  가";
				key    = "add";
				width  = 15;
				height = 2;
			}
			: button {
				label  = "삭  제";
				key    = "delete";
				width  = 15;
				height = 2;
			}
			: spacer {
				height = 1;
			}
			: button {    // defines the OK button
    				label = "확  인";
    				key = "accept";
    				width = 15;
    				height = 2;
    				fixed_width = true;
  			}
  			: button {    // defines the OK button
    				label = "취  소";
    				is_default = true;
    				key = "cancel";
    				width = 15;
    				height = 2;
    				fixed_width = true;
  			}
  			: spacer {
				height = 0.3;
			}
		}
		 
	
	}
	//ok_cancel;
}