jin_text_ts :dialog  {
	label="Change Text Style";
//	:boxed_row {
//		:text {label="선택옵션";}
//		:radio_button {
//			 label="선택한것만";
//			 key="jts_ch1";
//			 value=1;
//		}
//		:radio_button {
//			 label="도면전체를";
//			 key="jts_ch2";
//			 value=0;
//		}
//	}
	:boxed_row {
		label="첫번째 선택 문자형식";
		:column {
			:text {label="현재이름";	}
			:text {label="Name";	 key="jts_lic";	}
		}
		:column {
			:text {label="현재글꼴";	}
			:text {label="Font,Font";	 key="jts_fontc";	 }
		}
	}
//	:spacer { width=1; }
	:boxed_column {
		label="글꼴변경 메뉴 - 1";
		:text {label="문자형식                Font Name";}
		:row {
			:popup_list{
//					label="문자형식";
				key="jts_li";
				width=15;
			}
			:text {
				label="";
				key="jts_font";
				width=30;
			}
		}
		:spacer { width=1; }
	}
//	:boxed_column {
//		label="글꼴변경 메뉴 - 2 (도면전체)";
//		:text {label="문자형식                Font Name";}
//		:row {
//			:popup_list{
////				label="문자형식";
//				key="jts_lia";
//				width=15;
//			}
//			:text {
//				label="";
//				key="jts_fonta";
//				width=30;
//			}
//		}
//		:spacer { width=1; }
//	}
	ok_cancel_help;
}








jin_text_ts2 :dialog  {
	label="Change Text Style by Style";
	:boxed_column {
		label="바꿀 문자형식 선택";
		:text {label="문자형식                Font Name";}
		:row {
			:popup_list{
				key="jts_li";
				width=15;
			}
			:edit_box {
				key="jts_font";
				width=25;
			}
		}
		:text {label="";}
	}
	:boxed_column {
		label="대상 문자형식 선택";
		:text {label="문자형식                Font Name";}
		:row {
			:popup_list{
				key="jts_li2";
				width=15;
			}
			:edit_box {
				key="jts_font2";
				width=25;
			}
		}
		:text {label="";}
	}
	ok_cancel;
}
