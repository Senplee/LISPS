jintext_edit :dialog  {
  label="Text Changing command Box";
  :row {
    :boxed_radio_column {
      label="Command";
      :radio_button {
        label="1 by 1";
        key="jt_set_1";
      }
      :radio_button {
        label="Chg by Sel";
        key="jt_set_2";
      }
      :radio_button {
        label="T by T";
        key="jt_set_3";
      }
      :radio_button {
        label="Chg all";
        key="jt_set_4";
      }
      :radio_button {
        label="Add of Text";
        key="jt_set_56";
      }
      :radio_button {
        label="Text Hight";
        key="jt_set_7";
      }
      :radio_button {
        label="Text Width";
        key="jt_set_8";
      }
      :radio_button {
        label="Text Style";
        key="jt_set_9";
      }
      :radio_button {
        label="@(^.^)@";
        key="jt_set_0";
      }
    }
    :boxed_column {
      label= "Text's Description Editing";
      :row {
        :button {
          label="Change 1 by 1";
          key="jt_1";
        }
        :button {
          label="Select by All";
          key="jt_2";
        }
      }
      :boxed_column {
        label="Change Text by Text";
        :row {
          :button {
            label="��������";
            key="jt_3a";
          }
          :edit_box {
            key="jt_3a1";
            value="";
	    width=15;
          }
        }
        :row {
          :button {
            label="���湮��";
            key="jt_3b";
          }
          :edit_box {
            key="jt_3b1";
            value="";
	    width=15;
            allow_accept=true;
          }
        }
      }
      :boxed_row {
        :button {
          label="��ü����";
          key="jt_4";
        }
        :edit_box {
          key="jt_4a";
          value="";
          width=15;
          allow_accept=true;
        }
      }
      :column {
        label="Add Text";
        :row {
//          :toggle {
//            key="jt_5a1";
//          }
          :button {
            label="�����߰�";
            key="jt_5a2";
          }
          :edit_box {
            key="jt_5a3";
            edit_width=15;
            allow_accept=true;
          }
        }
        :row {
//          :toggle {
//            key="jt_6a1";
//          }
          :button {
            label="�����߰�";
            key="jt_6a2";
          }
          :edit_box {
            key="jt_6a3";
            edit_width=15;
            allow_accept=true;
          }
        }
      }
    }
    :boxed_column {
      label="Option's";
      :row {
        :button {
          label="����";
          key="jt_7a";
        }
        :edit_box {
          key="jt_7a1";
          edit_width=8;
          allow_accept=true;
        }
      }
      :row {
        :button {
          label="�ʺ�";
          key="jt_8a";
        }
        :edit_box {
          key="jt_8a1";
          edit_width=8;
          allow_accept=true;
        }
      }
      :row {
        :button {
          label="����";
          key="jt_9a";
        }
        :edit_box {
          key="jt_9a1";
          edit_width=8;
          allow_accept=true;
        }
      }
      :button {
        label="��������";
        key="jt_tp";
      }
      :button {
        label="������ġ";
        key="jt_ha";
      }
      :button {
        label="��������";
        key="jt_ep";
      }
      :button {
        label="��Ÿ�ϻ���";
        key="jt_st";
      }
    }
    :boxed_column {
      label="Position";
      :button {
        label="X�� ����";
        key="jtx";
      }
      :button {
        label="Y�� ����";
        key="jty";
      }
      :button {
        label="X,Y ����";
        key="jtx2";
      }
      :button {
        label="Rotation";
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
  }
  ok_cancel_help;
}

jintext_edit2 :dialog  {
  label="Text Changing command Box";
  :boxed_row {
    label="Select Text";
    :button {
      label="���ڼ���";
      key="jtt_sel1";
    }
    :edit_box {
      key="jtt_sel2";
      value="";
      width=50;
    }
  }
  ok_cancel;
}
