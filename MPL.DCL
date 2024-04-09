mpl:dialog { 
label = "mpl" ;
:column{
	label="용지설정";
	:popup_list{
		label="프린터 설정 : ";
		key="printlist";
	}
	
	:popup_list{
		label="용지 : ";
		key="paperlist";
	}
	:popup_list{
		label="플롯스타일 : ";
		key="plotlist";
	}
	:row{
	spacer;
	}
	
	spacer;
}
spacer;//정렬명령
:row{
:row{
	label="도면 설정";
	:list_box{
		key="dwg_list";
	}
	:column{
		:button{
			label="도면추가";
			key="fplus";
		}
		:button{
			label="도면삭제";
			key="fminus";
		}
	spacer_0;
		:button{
			label="순서위로";
			key="arrayup";
		}
		:button{
			label="순서아래로";
			key="arraydown";
		}
	spacer_1;//빈칸 추가
	spacer_1;//빈칸 추가

	}
}
spacer;
:column{
	:row{
	:radio_column{
		label="플롯대상";
		key="prb_key";
		:radio_button{
			label="모형,배치";
			key="prb0";
			is_default=true;
		}
		:radio_button{
			label="모형";
			key="prb1";
		}
		:radio_button{
			label="배치";
			key="prb2";
		}
	spacer;
	}
	spacer_1;
	:radio_column{
			label="출력방향";
			key="rb_key";
			:radio_button{ 
				key="rb0"; 
				label="가로"; 
				allow_accept=true; 
				
			}
			:radio_button{ 
				key="rb1"; 
				label="세로"; 
			}
	spacer_1;	spacer_1;	spacer_1;
	:button{
		label="도곽";
		key="sidline";
	}
	}
	spacer;
	}
	:row{
		label="파일설정";
		:toggle{label="저장경로 수정"; key="esave";}
		:button{label="경로"; key="spath"; is_enabled=false;}
		:edit_box{key="save"; edit_width=20; is_enabled=false;}
	}
}
}
	//ok_cancel;
	: row {
			 spacer;spacer_0;spacer_1;
			 : button { label = "확인"; key = "accept"; is_default = true; }
			 : button { label = "취소"; key = "cancel"; is_cancel=true;}
			 spacer;spacer_0;spacer_1;
	}
}

