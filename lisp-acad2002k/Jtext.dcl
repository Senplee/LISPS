jintext_edit :dialog  {
  label="Text Changing command Box";
  :row {
    :boxed_column {
      label= "Text's Descript";
      :button {
        label="1 by 1";
        key="jt_1";
      }
      :row {
        label="Same Text";
        :edit_box {
          label="원본";
          key="jt_2a";
        }
        :edit_box {
          label="변경";
          key="jt_2b";
        }
      }
      :edit_box {
        label="Change All";
        key="jt_3";
      }
      :button {
        label="Select by All";
        key="jt_4";
      }
      :button {
        label="TPL";
        key="jtpl";
      }
      :button {
        label="TPL2";
        key="jtpl2";
      }
      :button {
        label="TPL3";
        key="jtpl3";
      }
    }
    :boxed_column {
      label="Option's";
      :button {
        label="TH";
        key="jth";
      }
      :button {
        label="TW";
        key="jtw";
      }
      :button {
        label="TS";
        key="jts";
      }
      :button {
        label="TL";
        key="jtl";
      }
      :button {
        label="TF";
        key="jtf";
      }
      :button {
        label="TU";
        key="jtu";
      }
      :button {
        label="HST";
        key="jhst";
      }
    }
    :boxed_column {
      label="Position";
      :button {
        label="TX";
        key="jtx";
      }
      :button {
        label="TY";
        key="jty";
      }
      :button {
        label="TX2";
        key="jtx2";
      }
      :button {
        label="TR0";
        key="jtr0";
      }
      :button {
        label="TRA";
        key="jtra";
      }
      :button {
        label="";
      }
      :button {
        label="";
      }
    }
    :boxed_column {
      label="Other   ";
      :button {
        label="TNN";
        key="jtnn";
      }
      :button {
        label="TNN2";
        key="jtnn2";
      }
      :button {
        label="TAN";
        key="jtan";
      }
      :button {
        label="";
      }
      :button {
        label="";
      }
      :button {
        label="";
      }
      :button {
        label="";
      }
    }
  }
  ok_cancel;
}
