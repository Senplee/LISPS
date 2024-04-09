jinchbb :dialog  {
  label="Change Block-by-Block";
    :boxed_column {
      label="Select Block Name";
      :row {
        :button {
          label="Select Block";
          key="chbb_na1";
        }
        :edit_box {
          key="chbb_name1";
          value="";
          allow_accept=true;
        }
      }
      :row {
        :button {
          label="Service Block";
          key="chbb_na2";
        }
        :edit_box {
          key="chbb_name2";
          value="";
          allow_accept=true;
        }
      }
    }
    :boxed_row {
      label="Change Blcock's Option";
      :toggle {
        label="Angle";
        key="chbb_op1";
      }
      :toggle {
        label="Scale";
        key="chbb_op2";
      }
      :toggle {
        label="Layer";
        key="chbb_op3";
      }
    }
  ok_cancel;
}

jinroom_ltg :dialog {
  label="Lighting Fixture Type Select";
  :row {
    :boxed_column {
      label="FL-Normal";
      :button {
        label="FL120";
        key="fl120";
      }
      :button {
        label="FL220";
        key="fl220";
      }
      :button {
        label="FPL336A";
        key="fpl336A";
      }
      :button {
        label="FL132";
        key="fl132";
      }
      :button {
        label="FL232";
        key="fl232";
      }
      :button {
        label="FL332";
        key="fl332";
      }
      :button {
        label="FL436A";
        key="fl436a";
      }
    }
    :boxed_column {
      label="FL-Emer..";
      :button {
        label="FL120E";
        key="fl120e";
      }
      :button {
        label="FL220E";
        key="fl220e";
      }
      :button {
        label="FPL336AE";
        key="fpl336ae";
      }
      :button {
        label="FL132e";
        key="fl132e";
      }
      :button {
        label="FL232E";
        key="fl232e";
      }
      :button {
        label="FL332E";
        key="fl332e";
      }
      :button {
        label="FPL436AE";
        key="fpl436ae";
      }
    }
    :boxed_column {
      label="IL.......";
      :button {
        label="FPL213";
        key="fpl213";
      }
      :button {
        label="FPL213E";
        key="fpl213e";
      }
      :button {
        label="IL60";
        key="il60";
      }
      :button {
        label="IL60E";
        key="il60e";
      }
      :button {
        label="IL60B";
        key="il60b";
      }
      :button {
        label="IL60BE";
        key="il60be";
      }
      :button {
        label="ILO1";
        key="ilo1";
      }
    }
    :boxed_column {
      label="Other....";
      :button {
        label="DETD";
        key="detd";
      }
      :button {
        label="DETS";
        key="dets";
      }
      :button {
        label="DETC";
        key="detc";
      }
    }
  }
  :row {
    :edit_box {
      label="Block Name is:";
      key="ltg_sel";
      width=10;
      allow_accept=true;
    }
    :button {
      label=" --< Park D.S >-- ";
//      key="pds_key";
    }
  }
  ok_only;
}
