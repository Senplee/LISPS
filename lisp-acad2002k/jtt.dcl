jin_text_tt :dialog  {
  label="Change Text-by-Text          ";
    :boxed_column {
      label="Description Edit";
      :row {
        :button {
	         label="원본문자";
				is_tab_stop=false;
	         key="tt1_s";
        }
        :edit_box {
	        key="tt1";
	        value="";
			  width=40 ;
        }
      }
      :row {
        :button {
				label="변경문자";
				is_tab_stop=false;
				key="tt2_s";
        }
        :edit_box {
	         key="tt2";
	         value="";
				width=40;
				allow_accept=true;
        }
      }
    }
    :boxed_row {
      label="Change by Select";
      :button {
				label="대상문자";
				is_tab_stop=false;
				key="tt3_s";
      }
      :text {
				key="tt3";
				value="Select Text is : ";
				width=40;
//				allow_accept=true;
        }
      }
  ok_cancel;
}
