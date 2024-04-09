jinsing :dialog  {
  label="22.9kV Single-Line Daigram";
  :column {
    :boxed_row {
      label="Incomming Panel Zone";
        :column {
			  :button {
			    label="수전전압";
			  }
	        :button {
		       label="부하전류";
			  }
        }
        :column {
          :popup_list {
//            label="";
            value="0";
            fixed_width=true;
            edit_width=8;
            key="sing_volm";
            list="22.9kV \n6.6kV \n3.3kV";
          }
          :edit_box {
//          label="Total Amp.:";
	         fixed_width=true;
            edit_width=8;
            key="sing_ampm";
          }
        }
        :spacer { width=1; }
        :column {
			  :button {
			    label="CT Size";
	        }
          :button {
            label="FUSE Size";
          }
        }
        :column {
          :edit_box {
//            label="CT Size :";
          fixed_width=true;
            edit_width=7;
            key="sing_ctm";
          }
          :edit_box {
//            label="CT Size :";
          fixed_width=true;
            edit_width=7;
            key="sing_mof";
          }
        }
        :spacer { width=1; }
        :column {
          :button {
            label="Option";
            key="sing_opt";
            allow_accept=true;
          }
//        :spacer { width=2; }
          :button {
            label="Blank";
            key="blank1";
          }
        }
        :spacer { width=1; }
        :column {
          :button {
            label="Draw-Text";
            key="sing_txt";
            allow_accept=true;
          }
//        :spacer { width=2; }
          :button {
            label="<Park D.S>";
            key="pds_key";
          }
        }
    }
    :boxed_row {
      label="Tranformer & A.C.B Panel Zone";
        :boxed_column {
	  label="Item List";
	  :button {
	    label="1차전압";
	  }
	  :button {
	    label="1차전류";
	  }
	  :button {
	    label="1차CT";
	  }
	  :button {
	    label="변압기";
	  }
	  :button {
	    label="2차전압";
	  }
	  :button {
	    label="2차전류";
	  }
	  :button {
	    label="ACB-SIZE";
	  }
	  :button {
	    label="Capacitor";
	  }
	  :button {
	    label="Capa.전류";
	  }
	  :button {
	    label="Capa.차단기";
	  }
	}
        :boxed_column {
          label="TR #1";
          :edit_box {
//            label="PV :";
            fixed_width=true;
            edit_width=6;
            key="sing_vol11";
          }
          :edit_box {
//            label="PV Amp.:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp11";
          }
          :edit_box {
//            label="PV CT:";
            fixed_width=true;
            edit_width=6;
            key="sing_ct1";
          }
          :edit_box {
//            label="TR Size:";
            edit_width=6;
            fixed_width=true;
            key="sing_tr1";
          }
          :popup_list {
//            label="SV :";
            fixed_width=true;
            value="0";
            edit_width=11;
            key="sing_vol12";
            list="380/220V \n220V \n440V \n220/110V \n220/127V \n208/120V \n190/110V";
          }
          :edit_box {
//            label="SV Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp12";
          }
          :edit_box {
//            label="LV ACB:";
            fixed_width=true;
            edit_width=6;
            key="sing_acb1";
          }
          :edit_box {
//            label="Capa Size:";
            fixed_width=true;
            edit_width=6;
            key="sing_cap1";
          }
          :edit_box {
//            label="Capa Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_mccb1";
          }
          :edit_box {
//            label=" Capa CB:";
            fixed_width=true;
            edit_width=6;
            key="sing_af1";
          }
        }
        :boxed_column {
          label="TR #2";
          :edit_box {
//            label="PV :";
            fixed_width=true;
            edit_width=6;
            key="sing_vol21";
          }
          :edit_box {
//            label="PV Amp.:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp21";
          }
          :edit_box {
//            label="PV CT:";
            fixed_width=true;
            edit_width=6;
            key="sing_ct2";
          }
          :edit_box {
//            label="TR Size:";
            edit_width=6;
            fixed_width=true;
            key="sing_tr2";
          }
          :popup_list {
//            label="SV :";
            fixed_width=true;
            value="0";
            edit_width=11;
            key="sing_vol22";
            list="380/220V \n220V \n440V \n220/110V \n220/127V \n208/120V \n190/110V";
          }
          :edit_box {
//            label="SV Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp22";
          }
          :edit_box {
//            label="LV ACB:";
            fixed_width=true;
            edit_width=6;
            key="sing_acb2";
          }
          :edit_box {
//            label="Capa Size:";
            fixed_width=true;
            edit_width=6;
            key="sing_cap2";
          }
          :edit_box {
//            label="Capa Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_mccb2";
          }
          :edit_box {
//            label=" Capa CB:";
            fixed_width=true;
            edit_width=6;
            key="sing_af2";
          }
        }
        :boxed_column {
          label="TR #3";
          :edit_box {
//            label="PV :";
            fixed_width=true;
            edit_width=6;
            key="sing_vol31";
          }
          :edit_box {
//            label="PV Amp.:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp31";
          }
          :edit_box {
//            label="PV CT:";
            fixed_width=true;
            edit_width=6;
            key="sing_ct3";
          }
          :edit_box {
//            label="TR Size:";
            edit_width=6;
            fixed_width=true;
            key="sing_tr3";
          }
          :popup_list {
//            label="SV :";
            fixed_width=true;
            value="0";
            edit_width=11;
            key="sing_vol32";
            list="380/220V \n220V \n440V \n220/110V \n220/127V \n208/120V \n190/110V";
          }
          :edit_box {
//            label="SV Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp32";
          }
          :edit_box {
//            label="LV ACB:";
            fixed_width=true;
            edit_width=6;
            key="sing_acb3";
          }
          :edit_box {
//            label="Capa Size:";
            fixed_width=true;
            edit_width=6;
            key="sing_cap3";
          }
          :edit_box {
//            label="Capa Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_mccb3";
          }
          :edit_box {
//            label=" Capa CB:";
            fixed_width=true;
            edit_width=6;
            key="sing_af3";
          }
        }
        :boxed_column {
          label="TR #4";
          :edit_box {
//            label="PV :";
            fixed_width=true;
            edit_width=6;
            key="sing_vol41";
          }
          :edit_box {
//            label="PV Amp.:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp41";
          }
          :edit_box {
//            label="PV CT:";
            fixed_width=true;
            edit_width=6;
            key="sing_ct4";
          }
          :edit_box {
//            label="TR Size:";
            edit_width=6;
            fixed_width=true;
            key="sing_tr4";
          }
          :popup_list {
//            label="SV :";
            fixed_width=true;
            value="0";
            edit_width=11;
            key="sing_vol42";
            list="380/220V \n220V \n440V \n220/110V \n220/127V \n208/120V \n190/110V";
          }
          :edit_box {
//            label="SV Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_amp42";
          }
          :edit_box {
//            label="LV ACB:";
            fixed_width=true;
            edit_width=6;
            key="sing_acb4";
          }
          :edit_box {
//            label="Capa Size:";
            fixed_width=true;
            edit_width=6;
            key="sing_cap4";
          }
          :edit_box {
//            label="Capa Amp:";
            fixed_width=true;
            edit_width=6;
            key="sing_mccb4";
          }
          :edit_box {
//            label=" Capa CB:";
            fixed_width=true;
            edit_width=6;
            key="sing_af4";
          }
        }
    }
  }
  :text {
		label="..Hi.............................(^.^)";
  }
  ok_cancel_help;
}
