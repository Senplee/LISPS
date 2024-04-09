dcl_settings : default_dcl_settings { audit_level = 0; }
ddedits : dialog {
  label = "Dialog text editor";
  initial_focus="edt_txt";
  aspect_ratio=0;
  :text {
      label=""; 
      key="dsp_ver1";
  }
  :text {
      label=""; 
      key="dsp_ver2";
  }
  spacer_1;
  :row {
    :text { label="Text : ";    mnemonic="T";}
    :edit_box{
        key="edt_txt";
        edit_width=53;
        edit_limit=255;
        allow_accept=true;
    }
  }
  :row {
    :boxed_column {
       :text {label="Front";     mnemonic="F";}
       :popup_list{
          key="add_fst";
          edit_width=8;
        }
    }
    :boxed_column {
       :text {label="Replace Text";   mnemonic="R";}
       :popup_list{
          key="chg_txt";
          edit_width=20;
       }
    }
    :boxed_column {
       :text {label="End";  mnemonic="E";}
       :popup_list{
          key="add_lst";
          edit_width=8;
        }
    }
    :boxed_column {
      :button {
         label="Upper";
         key="upper";
         width=5;
         mnemonic="U";
      }
      :button {
         label="Lower";
         key="lower";
         width=5;
         mnemonic="L";
      }
    }
  }
  :row {
    spacer_1;
    ok_button;
    :button {
       label="Cancel";
       key="cancel";
       fixed_width=true;
       width=8;
       alignment=centered;
       is_cancel=true;
       mnemonic="C";
    }
    :button {
       label="Default";
       key="default";
       fixed_width=true;
       width=8;
       alignment=centered;
       mnemonic="D";
    }
    :button {
       label="chg. All";
       key="chg_all";
       fixed_width=true;
       width=8;
       alignment=centered;
       mnemonic="A";
    }
    :button {
       label="Select";
       key="chg_sel";
       fixed_width=true;
       width=8;
       alignment=centered;
       mnemonic="S";
    }
    spacer_1;
  }
}
