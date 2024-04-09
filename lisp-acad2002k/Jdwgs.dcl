jinbox :dialog  {
  label="Drawing Base Setting Box";
  :row {
	 :boxed_column {
		label="Drawing Base-Setting Scale";
		:edit_box {
                         label="도  면  축  척:";
			 key="jdws";
			 value=100.0;
			 width=7;
			 fixed_width=true;
		}
		:edit_box {
                         label="배선심볼축척:";
			 key="jwis";
			 value=1.0;
			 width=7;
		}
		:boxed_column {
			 label="삽입점 지정";
			 :radio_button {
				label="선의 정가운데:";
				key="jlww1";
			 }
			 :radio_button {
				label="선의 아무데나:";
				key="jlww2";
			 }
		}
		:edit_box {
                         label="치수선  축척:";
			 key="jdis";
			 value=100.0;
			 width=7;
		}
		:edit_box {
                         label="선자르기간격:";
			 key="jbrw";
			 value=200.0;
			 width=7;
		}
		:edit_box {
                         label="배선심볼간격:";
			 key="jbrf";
			 value=100.0;
			 width=7;
		}
		:spacer { width=1; }
		:spacer { width=1; }
		:boxed_column {
		  label="Default Scale's";
		  :popup_list {
			 label="Selece Scale";
			 value="0";
			 key="jds_li";
			 list="1/1 \n1/2 \n1/10 \n1/20 \n1/30 \n1/40 \n1/50 \n1/60 \n1/75 \n1/80 \n1/100 \n1/150 \n1/200 \n1/250 \n1/300 \n1/400 \n1/500 \n1/600 \n1/700 \n1/750 \n1/800 ";
		  }
		}
	 }
	 :spacer { width=1; }
	 :boxed_column {
		label="Drawing Tools Setting";
		:row {
			:text {
				value="File Name :";
			}
			:edit_box {
//				 label="File Name :";
				 key="jname";
				 value="Drawing File";
				 width=20;
			}
		}
		:toggle {
			 label=":Ortho mode";
			 key="jotm";
			 value=1;
		}
		:toggle {
			 label=":Sanp mode";
			 key="jsnm";
			 value=0;
		}
		:toggle {
			 label=":Grid mode";
			 key="jgrm";
			 value=0;
		}
		:toggle {
			 label=":Blip mode";
			 key="jblm";
			 value=1;
		}
		:spacer { width=1; }
		:boxed_column {
			 label="Setting LUPREC ";
			 :radio_button {
				label="Dot->0 = 0.     :";
				key="jdot0";
			 }
			 :radio_button {
				label="Dot->2 = 0.00   :";
				key="jdot2";
			 }
			 :radio_button {
				label="Dot->4 = 0.0000 :    ";
				key="jdot4";
			 }
		}
		:spacer { width=1; }
		:button {
			 label="LIMITS SETTING";
			 key="jlimit";
//			 allow_accept=true;
//			 fixed_width=true;
		}
		:button {
			 label="선종류축척->1";
			 key="jlltsc1";
//			 allow_accept=true;
//			 fixed_width=true;
		}
	 }
  }
  ok_cancel;
}
