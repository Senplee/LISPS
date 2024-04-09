jintext_no :dialog  {
  label="  * Text Numbering Work *  ";
  :row {
    :column {
      :boxed_column {
        label="Numbering";
        :edit_box {
          label="Start no. ?";
          key="jtnn_n1";
          edit_width=4;
//          fixed_width=true;
        }
        :edit_box {
          label="Next  no. ?";
          key="jtnn_n2";
          edit_width=4;
//          fixed_width=true;
        }
        :row {
          :button {
            label="End Text";
            key="jtnn_n3a";
          }
          :edit_box {
//            label="Last no. is";
            key="jtnn_n3";
//          edit_width=8;
//          fixed_width=true;
          }
        }
      }
      :boxed_column {
        label="Add Text";
        :row {
          :toggle {
            key="jtnn_a1";
          }
          :edit_box {
            label="Left  Add:";
            key="jtnn_a2";
            edit_width=8;
          }
        }
        :row {
          :toggle {
            key="jtnn_a3";
          }
          :edit_box {
            label="Right Add:";
            key="jtnn_a4";
            edit_width=8;
          }
        }
      }
    }
    :boxed_row {
      label="Sorting Text";
      :boxed_radio_column {
        :radio_button {
          key="jtnn_s1a";
        }
        :radio_button {
          key="jtnn_s2a";
        }
        :radio_button {
          key="jtnn_s3a";
        }
        :radio_button {
          key="jtnn_s4a";
        }
//        :radio_button {
//          key="jtnn_s00a";
//        }
      }
      :boxed_column {
        label="Select is Go!!";
        :button {
          label="Top -> Down";
          key=jtnn_s1;
        }
        :button {
          label="Down -> Top";
          key=jtnn_s2;
        }
        :button {
          label="Right -> Left";
          key=jtnn_s3;
        }
        :button {
          label="Left -> Right";
          key=jtnn_s4;
        }
//        :button {
//          label="@(^.^)@";
//          key=jtnn_s00;
//        }
      }
    }
    :boxed_column {
      label="Option's";
      :radio_button {
        label="Auto";
        key=jtnn_o1;
      }
      :radio_button {
        label="01 ~ 99";
        key=jtnn_o2;
      }
      :radio_button {
        label="001 ~ 999";
        key=jtnn_o3;
      }
      :radio_button {
        label="0001 ~ 9999";
        key=jtnn_o4;
      }
      :radio_button {
        label="None";
        key=jtnn_o5;
      }
      :spacer { width=1; }
//      :spacer { width=1; }
//      :spacer { width=1; }
    }
  }
  ok_cancel_help;
}

