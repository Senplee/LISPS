

text_image : image {
    key = "text_image";
    height       = 6;
    aspect_ratio = 1.5;
    color        = 0;
}
//dlist_autotext 	
//    : toggle {
//        label = /*MSG20*/"글자크기 자동설정";
//        key = "tg_text_auto";
//    }

dlist_textimage : column {
text_image;
//dlist_autotext;
dlist_dadan;
}

flist_textimage : column {
text_image;
:boxed_column {
	 label = "테이블 옵션";
	: toggle {
	        label = "빈 테이블삭제";
	        key = "tg_table_auto";

	}
	: toggle {
	        label = "자동 나누기";
	        key = "tg_next_auto";

	}
	}
}
dlist_dadan : boxed_column {
 label = "테이블 옵션";
   :edit_box {
	        label = /*MSG20*/"다단수: ";
	     	key = "ed_field_size";
	        edit_width = 6;
	    }}
dlist_title: boxed_row{
label = "제목(도면목록표)";
: popup_list {
	        label = /*MSG3*/"글꼴:";
	        key = "pop_textstyle3";
	        edit_width = 14;
	    }
	    : edit_box {
	        label = /*MSG20*/"크기: ";
	     	key = "ed_textsize3";
	        edit_width = 6;
	    }
	    }
dlist_field: boxed_row{
label = "항목(도면번호,도면명,축척)";
: popup_list {
	        label = /*MSG3*/"글꼴:";
	        key = "pop_textstyle1";
	        edit_width = 14;
	    }
	    : edit_box {
	        label = /*MSG20*/"크기: ";
	     	key = "ed_textsize1";
	        edit_width = 6;
	    }
	    }

flist_title: boxed_row{
label = "제목(실내재료 마감표)";
: popup_list {
	        label = /*MSG3*/"글꼴:";
	        key = "pop_textstyle3";
	        edit_width = 14;
	    }
	    : edit_box {
	        label = /*MSG20*/"크기: ";
	     	key = "ed_textsize3";
	        edit_width = 6;
	    }
	    }
flist_field: boxed_row{
label = "항목(층별...바닥...걸레받이...)";
: popup_list {
	        label = /*MSG3*/"글꼴:";
	        key = "pop_textstyle1";
	        edit_width = 14;
	    }
	    : edit_box {
	        label = /*MSG20*/"크기: ";
	     	key = "ed_textsize1";
	        edit_width = 6;
	    }
	    }	    
dlist_content: boxed_row{
label = "내용";
: popup_list {
	        label = /*MSG3*/"글꼴:";
	        key = "pop_textstyle2";
	        edit_width = 14;
	       alignment = centered ;
	    }
	    : edit_box {
	        label = /*MSG20*/"크기: ";
	     	key = "ed_textsize2";
	        edit_width = 6;
	    }
	    }
dlist_textstyle: column {
	 dlist_title;
	 dlist_field;
	 dlist_content;
}

flist_textstyle: column {
	 flist_title;
	 flist_field;
	 dlist_content;
}

dlist_text: boxed_row {
	label = "글꼴 설정";

	 dlist_textimage;
	 dlist_textstyle;
}
flist_text: boxed_row {
	label = "글꼴 설정";

	 flist_textimage;
	 flist_textstyle;
}
dlist_files: boxed_row {
	label="파일 입력";
	: button {
		        label = "파일읽기";
		        key = "bn_file_open";
		        //fixed_width = 2;
		    }
	: edit_box {   key = "ed_file_name";
			width = 35;
			    }

}
tbl_radio : radio_row {
    //children_alignment = centered ;
    key = "tbl_radio";
    : radio_button {
        label = /*MSG3*/"1 단";
        key = "rd_1";
    }
    : radio_button {
        label = /*MSG3*/"2 단";
        key = "rd_2";
    }
    : radio_button {
        label = /*MSG3*/"3 단";
        key = "rd_3";
    }
}
dlist_table: boxed_row {
	label = "테이블 스타일";
	tbl_radio;
}
dd_dlist : dialog {
    label = /*MSG46*/"도면 리스트 설정";
    dlist_text;
    //dlist_table;
    //:row {
    //dlist_dadan;
    dlist_files;
   // }
    ok_cancel_err; //_help_errtile;
}

dd_Flist : dialog {
	label = "실내 재료 마감표 설정";	
	flist_text;
//	:row {
//    flist_dadan;
    	dlist_files;
//    }
    ok_cancel_err;
}
messagebox : dialog {
//	spacer_1;
	:text {
	alignment = centered;
	width = 45;
	key = "tx_message";
	
	}
	:text {
	alignment = centered;

	width = 45;
	key = "tx_message2";
	}
	ok_cancel;
}