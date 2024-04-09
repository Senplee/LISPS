jinblock :dialog  {
  label=" Block's Control ";
  :row {
  :boxed_row {
    label="* Erase or Count Blcok *";
    :column {
      :text {
        label="Count Same-Block :";
      }
      :text {
        label="Erase Same-Block :";
      }
      :text {
        label="Select Same-Block:";
      }
      :text {
        label="Wblock Make (DWG):";
      }
      :text {
        label="Block Make (File):";
      }
      :text {
        label="<<Make by P.D.S>>:";
      }
    }
    :column {
      :button {
        label="CTT";
        key="jbct";
      }
      :button {
        label="EBK";
        key="jbeb";
      }
      :button {
        label="SBK";
        key="jbsb";
      }
      :button {
        label="WB";
        key="jbwb";
      }
      :button {
        label="BL";
        key="jbbl";
      }
      :button {
        label="..";
        key="jdel1";
      }
    }
  }
  :spacer { width=1; }
  :boxed_row {
    label="* Edit or Change Blcok *";
    :column {
      :text {
        label="Change Block  :";
      }
      :text {
        label="Explode Block :";
      }
      :text {
        label="Mirror-Explode:";
      }
      :text {
        label="Un-Scale Exp  :";
      }
      :text {
        label="Block-New     :";
      }
      :text {
        label="Block Scale-7 :";
      }
    }
    :column {
      :button {
        label="CHBB";
        key="jbch";
      }
      :button {
        label="EP";
        key="jbep1";
      }
      :button {
        label="MIEP";
        key="jbep2";
      }
      :button {
        label="BLO_EXP";
        key="jbep3";
      }
      :button {
        label="XP";
        key="jbxp";
      }
      :button {
        label="S7";
        key="jbs7";
      }
    }
  }
  }
  ok_cancel;
}

jinblock2 :dialog  {
  label="Block's Scale-Control [S7]";
  :boxed_column {
    label="Select Block Description";
    :edit_box {
      label="Select Block Name is  :";
      key="jsbn";
    }
    :edit_box {
      label="Select Block Scale is :";
      key="jsbs";
    }
  }
  :spacer { width=1; }
  :boxed_column {
    label="Scale Changing command";
    :radio_button {
      label="Block Scale at All Scale => All is New";
      key="jsa";
    }
    :radio_button {
      label="Blcok Scale at Reference Scale => Scale";
      key="jsr";
    }
    :radio_button {
      label="Blcok Scale at Select-Scale => Select by Scale";
      key="jsn";
    }
    :edit_box {
      label="Scale at --> :";
      key="jss";
      width=8;
    }
  }
  ok_cancel;
}

